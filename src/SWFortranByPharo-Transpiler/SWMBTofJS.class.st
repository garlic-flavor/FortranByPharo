"
I transpile Pharo to ECMAScript.
"
Class {
	#name : #SWMBTofJS,
	#superclass : #SWMethodBodyTranspiler,
	#category : #'SWFortranByPharo-Transpiler-JS'
}

{ #category : #accessing }
SWMBTofJS >> atBlock: aBlockNode [
	self isExpression ifTrue: [
		aBlockNode containsReturn ifTrue: [ self error: 'A return inside a closure behaves differently.' ].
		self put: '(function'; putArgsAndBodyAndReturn: self expression; put: ')'
	] ifFalse: [
		self halt.
	]

]

{ #category : #'as yet unclassified' }
SWMBTofJS >> atBoolean: trueOrFalse [
	self put: (trueOrFalse ifTrue: [ 'true' ] ifFalse: [ 'false' ])
]

{ #category : #accessing }
SWMBTofJS >> atCharacter: aChar [
	self
		put: '"';
		put: aChar;
		put: '"'

]

{ #category : #accessing }
SWMBTofJS >> atLiteralArray: aLiteralArray [
	self atArray: aLiteralArray
]

{ #category : #accessing }
SWMBTofJS >> atSymbol: aSymbol [
	self
		put: '"';
		put: aSymbol asString;
		put: '"'
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putArgsAndBody: anExpression [
	self putArgumentDeclaration: anExpression arguments;
		putBlock: anExpression

]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putArgsAndBodyAndReturn: anExpression [
	self putArgumentDeclaration: anExpression arguments;
		putBlockAndReturn: anExpression

]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putArgumentDeclaration [

]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putArgumentDeclaration: anArrayOfNode [
	self put: '('.
	anArrayOfNode do: [ :arg |
		self put: arg name
	] separatedBy: [ self put: ', ' ].
	self put: ')'
	
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putArrayFooter [
	self put: ']'
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putArrayHeader [
	self put: '['
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putArraySeparator [
	self put: ', '
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putAtIfAbsent [
	|res|
	res := self makeNewVariable: self expression result.
	self preserveCurrentStatement: [
		self put: res node name; put: ' = '; transpileChild: self children first;
		put: '[';  transpileChild: self children second; put: ']'; putStatementDelimiter; cr;
		put: 'if ('; put: res node name; put: '== null)';  putBlock: self children third assignTo: res node name; cr
	].
	self put: res node name

]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putAtPut [
	self
		transpileChild: self children first;
		put: '[';
		transpileChild: self children second;
		put: '] = ';
		transpileChild: self children third
	
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putBlock: anExpression [
	|child|
	self put: '{'; cr; incIndent.
	child := self copy
		expression: anExpression;
		isExpression: false;
		previousStream: self stream subStream;
		declarationStream: self stream subStream;
		stream: self stream subStream;
		putVariableDeclarations;
		putSequence.
	self stream
		append: child declarationStream;
		append: child previousStream;
		append: child stream.
	self decIndent; put: '}'

		
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putBlock: anExpression assignTo: aVarName [
	|child|
	self put: '{'; cr; incIndent.
	child := self copy
		expression: anExpression;
		isExpression: false;
		previousStream: self stream subStream;
		declarationStream: self stream subStream;
		stream: self stream subStream;
		putVariableDeclarations;
		putSequenceAssignTo: aVarName.
	self stream
		append: child declarationStream;
		append: child previousStream;
		append: child stream.
	self decIndent; put: '}'

		
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putBlock: anExpression with: args assignTo: aVarName [
	|child|
	self halt.
	self put: '{'; cr; incIndent.
	child := self copy
		expression: anExpression;
		isExpression: false;
		previousStream: self stream;
		declarationStream: self stream subStream;
		stream: self stream subStream;
		putVariableDeclarations;
		putSequenceAssignTo: aVarName.
	self stream
		append: child declarationStream;
		append: child stream.
	self decIndent; put: '}'

		
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putBlockAndReturn: anExpression [
	|child|
	self put: '{'; cr; incIndent.
	child := self copy
		expression: anExpression;
		isExpression: false;
		previousStream: self stream subStream;
		declarationStream: self stream subStream;
		stream: self stream subStream;
		putVariableDeclarations;
		putSequenceAndReturn.
	self stream
		append: child declarationStream;
		append: child previousStream;
		append: child stream.
	self decIndent; put: '}'

		
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putBoolean: trueOrFalse [
	self put: (trueOrFalse ifTrue: [ 'true' ] ifFalse: [ 'false' ])
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putCall [
	self transpileChild: self children first;
		putArguments: self children allButFirst
]

{ #category : #'code generation' }
SWMBTofJS >> putCascadeAsExpression [
	self node receiver class = RBVariableNode ifTrue: [
		self putCascadeAsExpressionSimple
	] ifFalse: [
		self putCascadeAsExpressionWithTemp
	]
]

{ #category : #'code generation' }
SWMBTofJS >> putCascadeAsExpressionSimple [
	self preserveCurrentStatement: [
		self children allButLastDo: [ :child |
			self putStatement: child
		]
	].
	self transpileChildWithoutBracket: self children last

]

{ #category : #'code generation' }
SWMBTofJS >> putCascadeAsExpressionWithTemp [
	|receiver rval rexp last|
	receiver := self children first children first.
	rval := self makeNewVariable: receiver result.
	rexp := SWExpression new
		node: (RBVariableNode named: rval node name);
		result: receiver result;
		yourself.
	self preserveCurrentStatement: [
		self put: rval node name; put: ' = '; transpileChildWithoutBracket: receiver; putStatementDelimiter; cr.
		self children allButLastDo: [ :child |
			child children at: 1 put: rexp.
			self putStatement: child
		]
	].
	last := self children last.
	last children at:1 put: rexp.
	self transpileChildWithoutBracket: last

]

{ #category : #'code generation' }
SWMBTofJS >> putCascadeAsNotExpression [
	self node receiver class = RBVariableNode ifTrue: [
		self putSequence; preventStatementDelimiter; preventNewline
	] ifFalse: [|rcv tmp|
		self halt.
		rcv := self children first children first.
		tmp := self makeNewVariable: rcv result.
		self put: '('; put: tmp name; put: ' = '; transpileChild: rcv; put: ', '; cr; incIndent.
		self children do: [:child|
			child children at: 1 put: (SWExpression new
				node: (RBVariableNode named: tmp name);
				result: rcv result;
				yourself).
			(self child: child)
				transpile.
		] separatedBy: [ self put: ', '; cr ].
		self put: ')'; decIndent
	]

]

{ #category : #'code generation' }
SWMBTofJS >> putClosure [
	|sequence|
	self node containsReturn ifTrue: [ self error: 'A return statement inside a closure differs when it is in Pharo or in ECMAScript.' ].
	self put: 'function('.
	self node arguments do: [ :each |
		self put: each name
	] separatedBy: [ self put: ', ' ].
	self put: '){'; cr; incIndent.

	self children allButLastDo: [ :child |
		(self child: child)
			putArgumentDeclaration
	].
	sequence := self children last.
	sequence children allButLastDo: [ :child |
		self transpileChildAsNotExpression: child
	].
	self putReturnKeyword; put: ' '.
	self transpileChild: sequence children last.
	self putStatementDelimiter; cr; decIndent; put: '}'
	

]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putEnsure [
	self isExpression ifTrue: [
		self putEnsureAsExpression
	] ifFalse: [
		self putEnsureAsNotExpression
	]

]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putEnsureAsExpression [
	|res|
	res := (self makeNewVariable: self expression result) node name.
	self preserveCurrentStatement: [
		self put: 'try '; putBlock: self children first assignTo: res.
		self put: ' finally '; putBlock: self children second; cr
	].
	self put: res

]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putEnsureAsNotExpression [
	self halt.

]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putExpressionDelimiter [
	self put: ', '
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putIfNotNil: strait [
	self isExpression ifTrue: [
		self putIfNotNilAsExpression: strait
	] ifFalse: [
		self putIfNotNilAsNotExpression: strait
	]

]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putIfNotNilAsExpression: strait [
	|receiver res|
	res := self makeNewVariable: self expression result.
	self children first node class = RBVariableNode ifTrue: [
		receiver := (self copy
			expression: self children first;
			stream: self stream subStream;
			transpile;
			stream) contents
	] ifFalse: [
		receiver := (self makeNewVariable: self children first result) node name.
		self preserveCurrentStatement: [
			self put: receiver; put: ' = '; transpileChildWithoutBracket: self children first;
				putStatementDelimiter; cr
		]
	].
	self preserveCurrentStatement: [
		self put: res node name; put: ' = '; put: receiver; putStatementDelimiter; cr;
			put: 'if(';
			put: res node name;
			put: (strait ifTrue: [ ' != null' ] ifFalse: [ ' == null' ]);
			put: ' )  '.
		strait ifTrue: [
			self putBlock: self children second with: { receiver } assignTo: res name
		] ifFalse: [
			self putBlock: self children second assignTo: res node name
		].
		self cr
	].
	self put: res node name

]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putIfNotNilAsNotExpression: strait [

	self put: 'if('.
	self transpileChildWithoutBracket: self children first;
		put: (strait ifTrue: [ ' != null' ] ifFalse: [ ' == null' ]);
		put: ')'; putBlock: self children second;
		preventStatementDelimiter

]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putIfNotNilIfNil: strait [
	self isExpression ifTrue: [
		self putIfNotNilIfNilAsExpression: strait
	] ifFalse: [
		self putIfNotNilIfNilAsNotExpression: strait
	]

]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putIfNotNilIfNilAsExpression: strait [
	|res|
	res := self makeNewVariable: self expression result.
	self preserveCurrentStatement: [
		self put: 'if(';
			transpileChild: self children first;
			put: (strait ifTrue: [ ' != null ' ] ifFalse: [ ' == null'  ]);
			put: ')';
			putBlock: self children second assignTo: res node name;
			put: ' else ';
			putBlock: self children third assignTo: res node name;
			cr
	].
	self put: res node name

]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putIfNotNilIfNilAsNotExpression: strait [
	self put: 'if(';
		transpileChild: self children first;
		put: (strait ifTrue: [ ' != null' ] ifFalse: [ ' == null'  ]);
		put: ')';
		putBlock: self children second;
		put: ' else ';
		putBlock: self children third;
		preventStatementDelimiter

]

{ #category : #'code generation' }
SWMBTofJS >> putIfTrue: strait [
	self isExpression ifTrue: [
		self putIfTrueAsExpression: strait
	] ifFalse: [
		self putIfTrueAsNotExpression: strait.
	]

]

{ #category : #'code generation' }
SWMBTofJS >> putIfTrueAsExpression: strait [
	|res|
	res := self makeNewVariable: self children second result.
	self preserveCurrentStatement: [
		self put: 'if('.
		strait ifFalse: [ self put: '!' ].
		self transpileChild: self children first;
			put: '){'; cr; incIndent;
			preserveDeclaration: [
				(self child: self children second)
					putVariableDeclarations;
					put: res name; put: ' = ';
					putSequenceAsExpression;
					putStatementDelimiter; cr
			];
			decIndent; put: '}'; preventStatementDelimiter
	]

]

{ #category : #'code generation' }
SWMBTofJS >> putIfTrueAsNotExpression: strait [
	self put: 'if('.
	strait ifFalse: [ self put: '!' ].
	self transpileChildWithoutBracket: self children first;
		put: ')';
		putBlock: self children second;
		preventStatementDelimiter

]

{ #category : #'code generation' }
SWMBTofJS >> putIfTrueIfFalse: strait [
	self isExpression ifTrue: [
		self putIfTrueIfFalseAsExpression: strait
	] ifFalse: [
		self putIfTrueIfFalseAsNotExpression: strait
	]

]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putIfTrueIfFalseAsExpression: strait [
	|res|
	res := (self makeNewVariable: self expression result) node name.
	self preserveCurrentStatement: [
		self 	put: 'if('.
		strait ifFalse: [ self put: '!' ].
		self transpileChildWithoutBracket: self children first; put: ')';
			putBlock: self children second assignTo: res;
			put: ' else ';
			putBlock: self children third assignTo: res;
			cr.
	].
	self put: res

]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putIfTrueIfFalseAsNotExpression: strait [
	self put: 'if('.
	strait ifFalse: [ self put: '!' ].
	self transpileChildWithoutBracket: self children first;
		put: ')';
		putBlock: self children second;
		put: ' else ';
		putBlock: self children third;
		preventStatementDelimiter

]

{ #category : #'code generation' }
SWMBTofJS >> putImport: anArray from: aSource [
	self put: 'import {'.
	anArray do: [ :each |
		self put: each
	] separatedBy: [
		self put: ', '
	].
	self
		put: '} from "../script/';
		put:  aSource;
		put: '.mjs"'
]

{ #category : #'code generation' }
SWMBTofJS >> putNew [
	self
		put: 'new ';
		transpileChild: self children first;
		putArguments: self children allButFirst

]

{ #category : #accessing }
SWMBTofJS >> putNil [
	self put: 'null'
]

{ #category : #enumerating }
SWMBTofJS >> putOnDo [
	self isExpression ifTrue: [
		self putOnDoAsExpression
	] ifFalse: [
		self putOnDoAsNotExpression
	]

]

{ #category : #enumerating }
SWMBTofJS >> putOnDoAsExpression [
	|result|
	result := self makeNewVariable: self children first result elementType.
	self preserveCurrentStatement: [
		self put: 'try ';
			putBlock: self children first assignTo: result node name;
			put: 'catch'.
		self children third arguments isNotEmpty ifTrue: [
			self putArgumentDeclaration: self children third arguments
		].
		self putBlock: self children third;
			cr
	].
	self put: result node name

]

{ #category : #enumerating }
SWMBTofJS >> putOnDoAsNotExpression [
	self put: 'try ';
		putBlock: self children first;
		put: ' catch '.
	self children third arguments isNotEmpty ifTrue: [
		self putArgumentDeclaration: self children third arguments
	].
	self putBlock: self children third;
		preventStatementDelimiter 

]

{ #category : #'code generation' }
SWMBTofJS >> putOrdinaryMessage [
	|methodClass receiverClass|

	self method ifNil: [ ^ super putOrdinaryMessage ].
	methodClass := self method methodClass.
	methodClass ifNil: [ ^ super putOrdinaryMessage ].
	methodClass isInstanceSide ifTrue: [ ^ super putOrdinaryMessage ].

	receiverClass := self receiverClass.
	methodClass = receiverClass ifTrue: [ ^ super putOrdinaryMessage ].

	self
		put: methodClass instanceSide name;
		putClassAccessor;
		put: self mangle;
		putClassAccessor;
		put: 'call';
		putArguments: self children

]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putPresentBlock: anExpression with: arg [
	|child|
	self put: '{'; cr; incIndent;
		put: 'var '; put: anExpression arguments first name; put: ' = '; put: arg; putStatementDelimiter; cr.
	child := self copy
		expression: anExpression;
		isExpression: false;
		previousStream: self stream;
		declarationStream: self stream subStream;
		stream: self stream subStream;
		putVariableDeclarations;
		putSequence.
	self stream
		append: child declarationStream;
		append: child stream.
	self decIndent; put: '}'

]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putQueryAtIfPresent [
	|rVal|
	self isExpression ifTrue: [ self error ].
	rVal := self makeNewVariable: self expression result.
	self put: rVal node name; put: ' = '; transpileChild: self children first;
		put: '.at('; transpileChild: self children second;  put: ')'; putStatementDelimiter; cr;
		put: 'if('; put: rVal node name; put: ' != null)'; putPresentBlock: self children third with: rVal node name;
		preventStatementDelimiter

]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putReturnKeyword [ 
	self put: 'return'
]

{ #category : #'code generation' }
SWMBTofJS >> putReturnSelf [
	self
		putReturnKeyword;
		put: ' ';
		put: 'this';
		putStatementDelimiter;
		cr
]

{ #category : #'code generation' }
SWMBTofJS >> putSelf [
	self halt; flag: #toRewrite.

	self put: (self receiverClass isClassSide ifTrue: [ self receiverClass soleInstance name ] ifFalse: [ 'self' ])
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putSelfClass [
	self put: self expression receiverClass instanceSide name
]

{ #category : #'code generation' }
SWMBTofJS >> putSelfDeclaration [

	self method methodClass isInstanceSide ifFalse: [ ^ self ].
	(self node allVariables anySatisfy: [ :each | each name = 'self' ]) ifFalse: [ ^ self ].

	self put: 'var self = this;'; cr
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putSequenceAndReturn [
	|lastchild|
	self children allButLastDo: [ :child |
		self putStatement: child
	].
	lastchild := self copy
		previousStream: self stream;
		stream: self stream subStream;
		putReturnKeyword; put: ' '; transpileChildWithoutBracket: self children last;
		putStatementDelimiter; cr;
		yourself.
	self stream append: lastchild stream

]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putSequenceAssignTo: aVarName [
	|lastchild|
	self children allButLastDo: [ :child |
		self putStatement: child
	].
	lastchild := self copy
		previousStream: self stream;
		stream: self stream subStream;
		put: aVarName; put: ' = '; transpileChildWithoutBracket: self children last;
		putStatementDelimiter; cr;
		yourself.
	self stream append: lastchild stream
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putStdOut [
	self
		put: 'console.log';
		putArguments: (self expression children copyFrom: 2 to: 2)

]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putVariable [
	self node name = 'self' ifTrue: [ |receiverClass|
		receiverClass := self receiverClass.
		receiverClass isClassSide ifTrue: [
			^ self put: receiverClass instanceSide name
		]
	].
	(self expression containsAsMember: self node name) ifTrue: [|rClass|
		rClass := self receiverClass.
		self
			put: (rClass isInstanceSide ifTrue: [ 'this' ] ifFalse: [ rClass instanceSide name ]);
			putClassAccessor; put: '_'
	].
	^ super putVariable
]

{ #category : #'code generation' }
SWMBTofJS >> putVariableDeclarationOf: name [
	self declarationStream
		put: 'var ';
		put: name;
		put: ' = null';
		putDelimiter;
		putLine.

]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putYourself [
	self transpileChild: self children first

]
