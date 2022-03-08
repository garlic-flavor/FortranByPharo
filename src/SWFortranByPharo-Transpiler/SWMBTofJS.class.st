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
		self put: '(function'; putArgsAndBody; put: ')'
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
SWMBTofJS >> atNil [
	self put: 'null'
]

{ #category : #accessing }
SWMBTofJS >> atSymbol: aSymbol [
	self
		put: '"';
		put: aSymbol asString;
		put: '"'
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putArgsAndBody [
	self putArgumentDeclaration: self node arguments;
		putBlockBodyWithLocalScope

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
	self
		transpileChildAsExpression: self children first;
		put: '['; transpileChildAsExpression: self children second; put: '] || '.
	(self child: self children third)
		putBlockBodyAsExpression
		
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putAtPut [
	self
		transpileChild: self children first;
		put: '[';
		transpileChildAsExpression: self children second;
		put: '] = ';
		transpileChildAsExpression: self children third
	
]

{ #category : #accessing }
SWMBTofJS >> putBlock [
	|functionized|
	functionized := (self isExpression and: [ self node arguments isNotEmpty or: [ self node temporaries isNotEmpty ] ]).
	functionized ifTrue: [
		self put: 'function('.
		self node arguments do: [ :each |
			self put: each name
		] separatedBy: [ self put: ', ' ].
		self put: '){'; cr; incIndent.
	].
	self children allButLastDo: [ :child |
		(self child: child)
			putArgumentDeclaration
	].
	self preserveDeclaration: [
		(self child: self children last)
			isExpression: (functionized not and: [ self isExpression ]);
			putSequence.
		self expression node class = RBMethodNode ifTrue: [
			self expression node lastIsReturn ifFalse: [
				self putReturnKeyword; put: ' this;'; cr
			]
		]
	].
	functionized ifTrue: [
		self
			decIndent; put: '}()'
	]
	

]

{ #category : #'code generation' }
SWMBTofJS >> putBlockAsExpression [
	self children allButLastDo: [ :child |
		(self child: child)
			putArgumentDeclaration
	].
	(self child: self children last)
		isExpression: true;
		putSequence.
	

]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putBlockBody [
	self halt.
	self parentStream: self stream;
		putVariableDeclarations;
		putSequence;
		decIndent; put: '}'

]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putBlockBody: anExpression [
	|child|
	self put: '{'; cr; incIndent.
	child := self copy
		expression: anExpression;
		isExpression: false;
		parentStream: self stream;
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
SWMBTofJS >> putBlockBody: anExpression assignTo: aVarName [
	|child|
	self put: '{'; cr; incIndent.
	child := self copy
		expression: anExpression;
		isExpression: false;
		parentStream: self stream;
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
SWMBTofJS >> putBlockBody: anExpression with: args assignTo: aVarName [
	|child|
	self halt.
	self put: '{'; cr; incIndent.
	child := self copy
		expression: anExpression;
		isExpression: false;
		parentStream: self stream;
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
SWMBTofJS >> putBlockBodyAsExpression [

	self putVariableDeclarations;
		putSequenceAsExpression


]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putBlockBodyAssignTo: varName [
	self put: '{'; cr; incIndent;
		preserveDeclaration: [
			self putVariableDeclarations.
			self children allButFirstDo: [ :child |
				self putStatement: child
			].
			self put: varName; put: ' = '; transpileChildAsExpressionWithoutBracket: self children last
		];
		cr; decIndent; put: '}'
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putBlockBodyWithLocalScope [
	self put: '{'; cr; incIndent;
		preserveDeclaration: [
			self putVariableDeclarations;
				putSequence
		];
		decIndent; put: '}'

]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putBoolean: trueOrFalse [
	self put: (trueOrFalse ifTrue: [ 'true' ] ifFalse: [ 'false' ])
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putCall [
	self transpileChildAsExpression: self children first;
		putArguments: self children allButFirst
]

{ #category : #'code generation' }
SWMBTofJS >> putCascadeAsExpression [
	self node receiver class = RBVariableNode ifTrue: [
		self halt.
		self putSequenceAsExpression.
	] ifFalse: [|receiver rval rexp last|
		receiver := self children first children first.
		rval := self makeNewVariable: receiver result.
		rexp := SWExpression new
			node: (RBVariableNode named: rval name);
			result: receiver result;
			yourself.
		self preserveCurrentStatement: [
			self put: rval name; put: ' = '; transpileChildAsExpressionWithoutBracket: receiver; putStatementDelimiter; cr.
			self children allButLastDo: [ :child |
				child children at: 1 put: rexp.
				self putStatement: child
			]
		].
		last := self children last.
		last children at:1 put: rexp.
		self transpileChildAsExpression: last
	]
]

{ #category : #'code generation' }
SWMBTofJS >> putCascadeAsNotExpression [
	self node receiver class = RBVariableNode ifTrue: [
		self putSequence; preventStatementDelimiter; preventNewline
	] ifFalse: [|rcv tmp|
		self halt.
		rcv := self children first children first.
		tmp := self makeNewVariable: rcv result.
		self put: '('; put: tmp name; put: ' = '; transpileChildAsExpression: rcv; put: ', '; cr; incIndent.
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
	self transpileChildAsExpression: sequence children last.
	self putStatementDelimiter; cr; decIndent; put: '}'
	

]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putEnsure [
	self isExpression ifTrue: [
		self put: 'function() { try { '; cr; incIndent; put: 'return '.
		(self child: self children first)
			isExpression: true;
			putBlock.
		self putStatementDelimiter; cr; decIndent; put: '} finally {'; cr; incIndent.
		(self child: self children second)
			isExpression: false;
			putBlock.
		self putStatementDelimiter; cr; decIndent; put: '}}()'
	] ifFalse: [
		self halt.
	]

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
		receiver := self children first node name
	] ifFalse: [
		receiver := (self makeNewVariable: self children first result) name.
		self preserveCurrentStatement: [
			self put: receiver; put: ' = '; transpileChildAsExpressionWithoutBracket: self children first;
				putStatementDelimiter; cr
		]
	].
	self preserveCurrentStatement: [
		self put: 'if(';
			put: receiver;
			put: (strait ifTrue: [ ' != null' ] ifFalse: [ ' == null' ]);
			put: ' )  '.
		strait ifTrue: [
			self putBlockBody: self children second with: { receiver } assignTo: res name
		] ifFalse: [
			self putBlockBody: self children second assignTo: res name
		].
		self cr
	].
	self put: res name

]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putIfNotNilAsNotExpression: strait [
	self isExpression ifTrue: [|conditionNode closured receiver|
		conditionNode := self children first node.
		closured := conditionNode class ~= RBVariableNode.
		receiver := closured ifTrue: [ [ self put: '_receiver_' ] ] ifFalse: [ [ self transpileChildAsExpression: self children first ] ].

		closured ifTrue: [ self put: 'function(_receiver_){'; cr; incIndent; put: 'return ' ].
		self put: '('.
		receiver value.
		self put: (strait ifTrue: [ ' == ' ] ifFalse: [ ' != ' ]); put: ' null ? '.
		receiver value.
		self put: ' : '.
		(self child: self children second)
			isExpression: true;
			putBlock.
		self  put: ')'.
		closured ifTrue: [
			self
				putStatementDelimiter; cr; decIndent;
				put: '}('; transpileChildAsExpression: self children first; put: ')'
		]
	] ifFalse: [
		self put: 'if('.
		strait ifFalse: [ self put: '!' ].
		(self child: self children first)
			isExpression: true;
			transpile.
		self put: '){'; cr; incIndent.
		(self child: self children second)
			isExpression: false;
			putBlock.
		self decIndent; put: '}'; preventStatementDelimiter
	]

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
			transpileChildAsExpression: self children first;
			put: (strait ifTrue: [ ' != null ' ] ifFalse: [ ' == null'  ]);
			put: ')';
			putBlockBody: self children second assignTo: res name;
			put: ' else ';
			putBlockBody: self children third assignTo: res name;
			cr
	].
	self put: res name

]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putIfNotNilIfNilAsNotExpression: strait [
	self put: 'if(';
		transpileChildAsExpression: self children first;
		put: (strait ifTrue: [ ' != null' ] ifFalse: [ ' == null'  ]);
		put: ')';
		putBlockBody: self children second;
		put: ' else ';
		putBlockBody: self children third;
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
		self transpileChildAsExpression: self children first;
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
	self transpileChildAsExpression: self children first;
		put: ')';
		putBlockBody: self children second;
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
	res := self makeNewVariable: self expression result.
	self preserveCurrentStatement: [
		self put: 'If('.
		strait ifFalse: [ self put: '!' ].
		self transpileChildAsExpression: self children first;
			put: ')';
			putBlockBody: self children second assignTo: res name;
			put: ' else ';
			putBlockBody: self children second assignTo: res name;
			cr.
	].
	self put: res name

]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putIfTrueIfFalseAsNotExpression: strait [
	self put: 'if('.
	strait ifFalse: [ self put: '!' ].
	self transpileChildAsExpression: self children first;
		put: ')';
		putBlockBody: self children second;
		put: ' else ';
		putBlockBody: self children third;
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
		transpileChildAsExpression: self children first;
		putArguments: self children allButFirst

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
		self put: 'try {'; cr; incIndent; put: result name; put: ' = '.
		(self child: self children first)
			putSequenceAsExpression.
		self putStatementDelimiter; cr; decIndent; put: '} catch'.
		(self child: self children third)
			putArgsAndBody.
		self cr.
	].
	self put: result name

]

{ #category : #enumerating }
SWMBTofJS >> putOnDoAsNotExpression [
	self put: 'try '.
	(self child: self children first)
			putBlockBodyWithLocalScope.
	self put: ' catch '.
	self children third arguments isNotEmpty ifTrue: [
		(self child: self children third)
			putArgsAndBody
	] ifFalse: [
		(self child: self children third)
			putBlockBodyWithLocalScope.
	].
	self preventStatementDelimiter 

]

{ #category : #'code generation' }
SWMBTofJS >> putOpBinary: aNode [
	self halt; flag: #toRewrite.
	super putOpBinary: (aNode selector = #= ifTrue: [
		aNode copy
			selector: #==;
			yourself
	] ifFalse: [ aNode ])
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
SWMBTofJS >> putQueryAtIfPresent [
	|rVal|
	self isExpression ifTrue: [ self error ].
	rVal := self makeNewVariable: self expression result.
	self put: rVal name; put: ' = '; transpileChildAsExpression: self children first;
		put: '.at('; transpileChildAsExpression: self children second;  put: ')'; putStatementDelimiter; cr;
		put: 'if('; put: rVal name; put: ' != null){'; cr; incIndent;
		put: 'var '; put: self children third arguments first name; put: ' = '; put: rVal name; putStatementDelimiter; cr.
	(self child: self children third)
		putSequence.
	self decIndent; put: '}'; preventStatementDelimiter

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
	self put: 'var self = this;'; cr
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putSequenceAssignTo: aVarName [
	self children allButLastDo: [ :child |
		self putStatement: child
	].
	self put: aVarName; put: ' = '; putStatementAsExpression: self children last;
		putStatementDelimiter; cr

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
