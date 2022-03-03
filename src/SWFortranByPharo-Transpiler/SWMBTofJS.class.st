"
I transpile Pharo to ECMAScript.
"
Class {
	#name : #SWMBTofJS,
	#superclass : #SWMethodBodyTranspiler,
	#category : #'SWFortranByPharo-Transpiler-JS'
}

{ #category : #'as yet unclassified' }
SWMBTofJS >> atBoolean: trueOrFalse [
	self put: (trueOrFalse ifTrue: [ 'true' ] ifFalse: [ 'false' ])
]

{ #category : #'code generation' }
SWMBTofJS >> atCascade: aCascadeNode [
	aCascadeNode receiver class = RBVariableNode ifTrue: [
		self putSequence.
		self isExpression ifFalse: [
			self 	preventStatementDelimiter; preventNewline
		]
	] ifFalse: [|receiver original|
		receiver := self children first children first.
		original := self children.
		self put: 'function(_receiver_){'; cr; incIndent; put: 'return ('; cr; incIndent.
		self children do: [:child|
			child children at: 1 put: (SWExpression new
				node: (RBVariableNode named: #_receiver_ );
				result: receiver result;
				yourself).
			(self child: child)
				transpile.
		] separatedBy: [ self put: ', '; cr ].
		
		self put: ');'; cr; decIndent; decIndent; put: '}('.
		(self child: receiver)
			isExpression: true;
			transpile.
		self put: ')'
	]

]

{ #category : #accessing }
SWMBTofJS >> atClosure: aBlockNode [
	self isExpression: false.
	self putClosure

]

{ #category : #accessing }
SWMBTofJS >> atSymbol: aSymbol [
	self
		put: '"';
		put: aSymbol asString;
		put: '"'
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putArgumentDeclaration [
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
	(self child: self children last)
		isExpression: (functionized not and: [ self isExpression ]);
		putSequence.
	self expression node class = RBMethodNode ifTrue: [
		self expression node lastIsReturn ifFalse: [
			self putReturnKeyword; put: ' this;'; cr
		].
	].
	functionized ifTrue: [
		self
			decIndent; put: '}()'
	]
	

]

{ #category : #'code generation' }
SWMBTofJS >> putBlockAsExpression: aBlock [
	self halt; flag: #toRewrite.

	aBlock statements size = 1 ifTrue: [
		self << (aBlock statements at: 1)
	] ifFalse: [
		self
			put: '(';
			putClosure: aBlock;
			put: ')()'
	]
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putBoolean: trueOrFalse [
	self put: (trueOrFalse ifTrue: [ 'true' ] ifFalse: [ 'false' ])
]

{ #category : #'code generation' }
SWMBTofJS >> putClosure [
	|sequence|
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
SWMBTofJS >> putIfNotNil: strait [
	self isExpression ifTrue: [|conditionNode|
		conditionNode := self children first node.
		conditionNode class = RBVariableNode ifTrue: [
			self put: '('.
			self transpileChildAsExpression: self children first.
			self
				put: (strait ifTrue: [ ' == ' ] ifFalse: [ ' != ' ]);
				put: ' null ? '.
			self transpileChildAsExpression: self children first.
			self
				put: ' : '.
			(self child: self children second)
				isExpression: true;
				putBlock.
			self  put: ')'
		] ifFalse: [
			self halt.
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
		self put: '('.
		(self child: self children first)
			isExpression: true;
			transpile.
		self put: (strait ifTrue: [ ' != null ' ] ifFalse: [ ' == null'  ]).
		self put: ' ? '.
		(self child: self children second)
			isExpression: true;
			putBlock.
		self 	put: ' : '.
		(self child: self children third)
			isExpression: true;
			putBlock.
		self put: ')'.
	] ifFalse: [
		self put: 'if('.
		(self child: self children first)
			isExpression: true;
			transpile.
		self put: (strait ifTrue: [ ' != null' ] ifFalse: [ ' == null'  ]).
		self put: '){'; cr; incIndent.
		(self child: self children second)
			isExpression: false;
			putBlock.
		self decIndent; put: '} else {'; cr; incIndent.
		(self child: self children third)
			isExpression: false;
			putBlock.
		self decIndent; put: '}'; preventStatementDelimiter
	]

]

{ #category : #'code generation' }
SWMBTofJS >> putIfTrue: strait [
	self isExpression ifTrue: [
		self halt.
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

{ #category : #'code generation' }
SWMBTofJS >> putIfTrueIfFalse: strait [
	self isExpression ifTrue: [
		self put: '('.
		strait ifFalse: [ self put: '!' ].
		(self child: self children first)
			isExpression: true;
			transpile.
		self put: ' ? '.
		(self child: self children second)
			isExpression: true;
			putBlock.
		self 	put: ' : '.
		(self child: self children third)
			isExpression: true;
			putBlock.
		self put: ')'.
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
		self decIndent; put: '} else {'; cr; incIndent.
		(self child: self children third)
			isExpression: false;
			putBlock.
		self decIndent; put: '}'; preventStatementDelimiter
	]

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

{ #category : #'as yet unclassified' }
SWMBTofJS >> putNil [
	self halt; flag: #toRewrite.
	self put: 'null'
]

{ #category : #enumerating }
SWMBTofJS >> putOnDo [
	self isExpression ifTrue: [
		self put: 'function(){ try {'; cr; incIndent; put: 'return '.
		(self child: self children first)
			isExpression: true;
			putBlock.
		self putStatementDelimiter; cr; decIndent; put: '} catch {'; cr; incIndent; put: 'return '.
		(self child: self children third)
			isExpression: true;
			putBlock.
		self putStatementDelimiter; cr; decIndent; put: '}}()'
	] ifFalse: [
		self put: 'try {'; cr; incIndent.
		(self child: self children first)
			isExpression: false;
			putBlock.
		self decIndent; put: '} catch {'; cr; incIndent.
		(self child: self children third)
			isExpression: false;
			putBlock.
		self decIndent; put: '}'; preventStatementDelimiter 
	]

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

{ #category : #'code generation' }
SWMBTofJS >> putSelfDeclaration [
	self put: 'var self = this;'; cr
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
	self node name = 'super' ifTrue: [
		^ self put: 'super'
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
SWMBTofJS >> putVariableDeclaration [
	self
		put: 'var ';
		put: self node name;
		put: ' = null'
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putYourself [
	self transpileChild: self children first

]

{ #category : #'as yet unclassified' }
SWMBTofJS >> put_upToEnd: aNode [
	self error; flag: #toRemove.
	self
		withoutMessageNestDo: [
			self << aNode receiver
		];
		putClassAccessor;
		put: 'read()'
]
