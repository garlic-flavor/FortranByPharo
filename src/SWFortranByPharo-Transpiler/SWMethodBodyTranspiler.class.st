"
I transpile a method of Pharo class.
"
Class {
	#name : #SWMethodBodyTranspiler,
	#superclass : #Object,
	#instVars : [
		'decoder',
		'stream',
		'pool'
	],
	#category : #'SWFortranByPharo-Transpiler-Common'
}

{ #category : #constants }
SWMethodBodyTranspiler class >> mangleClass [
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler class >> methodDefinitionTranspilerClass [ 
	^ self subclassResponsibility
]

{ #category : #'instance creation' }
SWMethodBodyTranspiler class >> new: decoder [
	^ self new
		decoder: decoder;
		yourself
]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler class >> poolClass [
	^ SWTranspilerPool
]

{ #category : #accessing }
SWMethodBodyTranspiler class >> senderTranspilerClass [
	self halt; flag: #toRewrite.
	^ SWSenderTranspiler
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> << anObject [
	self halt; flag: #toRemove.
	anObject dispatchTo: self

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> atCascade: aCascadeNode [
	aCascadeNode leftmostChainReceiver class = RBVariableNode ifTrue: [
		self
			transpileChildrenWithDelimiter;
			preventStatementDelimiter;
			preventNewline
	] ifFalse: [
		self halt.
	]

]

{ #category : #accessing }
SWMethodBodyTranspiler >> atMessage: aMessageNode [
	(self pool predefinedSenderTranspiler: self decoder sender) ifNotNil: [ :predefined |
		predefined value: self
	] ifNil: [
		self
			transpileChild: self decoder children first;
			putClassAccessor;
			put: self mangle;
			putArguments: (self decoder children copyFrom: 2 to: self decoder children size)
	]

]

{ #category : #accessing }
SWMethodBodyTranspiler >> atMethod: aMethodNode [
	self transpileChildren.

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> atReturn: aReturnNode [
	self put: 'return '.
	self transpileChildren

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> atSequence: aSequenceNode [
	self transpileChildrenWithDelimiter

]

{ #category : #accessing }
SWMethodBodyTranspiler >> atString: aString [
	self
		put: '"';
		put: aString;
		put: '"'
]

{ #category : #accessing }
SWMethodBodyTranspiler >> atVariable: aVariableNode [
	self put: aVariableNode name

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> cr [

	self stream putLine
]

{ #category : #'code generation - protected' }
SWMethodBodyTranspiler >> decIndent [
	self halt; flag: #toRemove.
	self stream decIndent
]

{ #category : #'private - code generation' }
SWMethodBodyTranspiler >> decMessageNest [
	self halt; flag: #toRemove.
	messageNest := messageNest - 1.
	0 < messageNest ifTrue: [ self put: ')' ].

]

{ #category : #accessing }
SWMethodBodyTranspiler >> decoder [

	^ decoder
]

{ #category : #accessing }
SWMethodBodyTranspiler >> decoder: anObject [

	decoder := anObject
]

{ #category : #accessing }
SWMethodBodyTranspiler >> generator [
	self halt; flag: #toRewrite.
	^ generator ifNil: [ generator := [ :transpiler | |m|
		m := transpiler method.

		transpiler locals do: [ :each | self putVariableDeclarationOf: each name ].
		(transpiler classInfo isNotNil and: [ m methodClass isInstanceSide ]) ifTrue: [
			self putSelfDefinition
		].
		transpiler putSequence: m sourceNode body.
		(transpiler classInfo isNotNil and: [ m sourceNode lastIsReturn not]) ifTrue: [
			transpiler putReturnSelf
		]
	] ]
]

{ #category : #accessing }
SWMethodBodyTranspiler >> generator: anObject [
	self halt; flag: #toRemove.

	generator := anObject
]

{ #category : #'code generation - protected' }
SWMethodBodyTranspiler >> incIndent [
	self halt; flag: #toRewrite.
	self stream incIndent
]

{ #category : #'private - code generation' }
SWMethodBodyTranspiler >> incMessageNest [
	self halt; flag: #toRewrite.
	messageNest := messageNest + 1.
	1 < messageNest ifTrue: [ self put: '(' ].
]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> mangle [
	^ self class mangleClass mangle: self decoder
]

{ #category : #'private - code generation' }
SWMethodBodyTranspiler >> mangle: aName [
	self error; flag: #toRemove.
	^ self class mangleClass mangle: aName
]

{ #category : #accessing }
SWMethodBodyTranspiler >> messageNest [
	self halt; flag: #toRewrite.

	^ messageNest ifNil: [ messageNest := 0 ]
]

{ #category : #accessing }
SWMethodBodyTranspiler >> messageNest: anObject [
	self halt; flag: #toRewrite.

	messageNest := anObject
]

{ #category : #'instance creation' }
SWMethodBodyTranspiler >> newFullClosure: lit with: operands [
	self halt; flag: #toRewrite.
	^ (super newFullClosure: lit with: operands)
		stream: self stream;
		generator: [ :transpiler | |node|
			node := transpiler method sourceNode.
			transpiler putBlock: node				
"
			transpiler
				put: '{';
				incIndent;
				cr.
			transpiler locals do: [ :each | self putVariableDeclarationOf: each name ].
			transpiler putSequence: m sourceNode body.
			transpiler
				decIndent;
				put: '}';
				preventStatementDelimiter 
"
		];
		yourself
]

{ #category : #accessing }
SWMethodBodyTranspiler >> pool [

	^ pool ifNil: [
		pool  := self class poolClass new
			owner: self
			yourself
	]
]

{ #category : #accessing }
SWMethodBodyTranspiler >> pool: anObject [

	pool := anObject
]

{ #category : #'code generation - protected' }
SWMethodBodyTranspiler >> preventNewline [
	self stream preventNewline
]

{ #category : #'code generation - protected' }
SWMethodBodyTranspiler >> preventStatementDelimiter [
	self stream preventDelimiter
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> put: anObject [
	self stream put: anObject asString
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putArguments: arguments [

	self put: '('.
	arguments do: [ :each |
		self transpileChild: each
	] separatedBy: [
		self put: ', '
	].

	self put: ')'

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putArray: anArray [
	self halt; flag: #toRewrite.

	self put: '['.
	anArray do: [:each |
		self << each
	] separatedBy: [
		self put: ', '
	].
	self put: ']'.

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putAssignTo: key with: value [
	self halt; flag: #toRewrite.

	self
		<< key;
		put: ' = ';
		<< value

]

{ #category : #streaming }
SWMethodBodyTranspiler >> putBasenameOn: aStream [
	self halt; flag: #toRewrite.
	aStream
		<< self receiverClass instanceSide name;
		<< self selector asCamelCase
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putBlock: aBlockNode [
	self halt; flag: #toRewrite.

	self
		put: '{';
		putSequence: aBlockNode body;
		put: '}'
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putBlockAsExpression: aBlock [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putCascade: aRBCascadeNode [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putCharacter: c [
	self halt; flag: #toRewrite.
	self
		put: '"';
		put: c asString;
		put: '"'.
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putClassAccessor [
	self put: '.'
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putClosure: aNode [
	|tran|
	self halt; flag: #toRewrite.
	tran := self senders at: aNode.
	tran transpile.

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putCode: code [
	self halt; flag: #toRewrite.
	^ self putCode: code with: {  }
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putCode: code with: anAssociationArray [
	"when a line in code ends with $\, the line continues to the next."
	|matcher leftPad escaped|
	self halt; flag: #toRewrite.

	matcher := RxMatcher forString: '(\\\r|\s+\\$)'.
	escaped := matcher copy: code replacingMatchesWith: ''.
	leftPad := (escaped findFirst: [ :c | c ~= Character tab ])-1.
	matcher := RxMatcher forString: '\t+'.
	escaped := matcher copy: escaped translatingMatchesUsing: [ :m |
		String tab repeat: (m size - leftPad)
	].
	anAssociationArray do: [ :each |
		escaped := escaped copyReplaceAll: each key with: each value.
	].
	self put: escaped.


]

{ #category : #streaming }
SWMethodBodyTranspiler >> putFilenameOn: aStream [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putIfFalse: aNode [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putIfTrue: aNode [
	^ self subclassResponsibility
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putIfTrueIfFalse [
	^ self subclassResponsibility
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putIfTrueIfFalse: aNode [
	^ self subclassResponsibility
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putImport: anArray from: aSource [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putInteger: anInteger [
	self halt; flag: #toRewrite.
	self put: anInteger asString
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putLine: anObject [
	self halt; flag: #toRewrite.
	self stream putLine: anObject asString
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putMessage: aNode [
	self halt; flag: #toRewrite.
	self incMessageNest.
	self << (self senders at: aNode).
	self decMessageNest
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putMessage: aNode withReceiver: aRNode [
	|sender|
	self halt; flag: #toRewrite.
	sender := (self senders at: aNode) copy.
	sender node: (aNode copy
		receiver: aRNode
		yourself).
	self << sender
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putNew: aNode [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> putNil [
	self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putOpBinary: aNode [
	self halt; flag: #toRewrite.
	self
		<< aNode receiver;
		put: ' ';
		put: aNode selector;
		put: ' ';
		<< (aNode arguments at: 1)

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putParameters: anArray [
	self halt; flag: #toRewrite.

	anArray do: [:each |
		self put: each asString
	] separatedBy: [
		self put: ', '
	]

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putReturn: value [
	self halt; flag: #toRewrite.
	
	^ self
		put: 'return ';
		withoutMessageNestDo: [
			self << value
		]
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putReturnSelf [
	self halt; flag: #toRewrite.
	self putStatement: (RBReturnNode value: (RBVariableNode named: 'self'))
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putSelf [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putSelfDefinition [
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> putSender: aNode with: aSender [
	self halt; flag: #toRewrite.
	self
		<< aNode receiver;
		putClassAccessor;
		put: aSender;
		putArguments: aNode arguments
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putSequence: aSequence [
	self halt; flag: #toRewrite.
	self withoutMessageNestDo: [
		aSequence statements do: [ :each |
			self putStatement: each
		]
	]
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putSequenceWithReturn: aSequence [
	self halt; flag: #toRewrite.
	self withoutMessageNestDo: [
		aSequence statements doWithIndex: [ :each :index |
			((aSequence isLast: each) and: [ each class ~= RBReturnNode ]) ifTrue: [
				self
					putReturn: each;
					putStatementDelimiter;
					cr
			] ifFalse: [
				self putStatement: each
			]
		]
	]
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putStatement: aStatement [
	self halt; flag: #toRewrite.
	self
		<< aStatement;
		putStatementDelimiter;
		cr

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putStatementDelimiter [
	self stream putDelimiter
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putString: aString [
	self halt; flag: #toRewrite.
	self
		put: '"';
		put: aString;
		put: '"'.
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putSymbol: aByteSymbol [
	self halt; flag: #toRewrite.
	self stream
		put: '"';
		put: aByteSymbol asString;
		put: '"'
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putVariable: aVariableNode [
	self halt; flag: #toRewrite.

	aVariableNode name = #self ifTrue: [
		^ self putSelf
	].
	(self classInfo isNotNil and: [ self classInfo hasVariable: aVariableNode name ]) ifTrue: [
		self
			putSelf;
			putClassAccessor;
			put: '_'
	].
	self put: aVariableNode name

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putVariableDeclarationOf: aVariableInfo [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWMethodBodyTranspiler >> stream [
	^ stream ifNil: [ stream := SWTranspilerStream new ]

]

{ #category : #accessing }
SWMethodBodyTranspiler >> stream: anObject [

	stream := anObject.

]

{ #category : #'public API' }
SWMethodBodyTranspiler >> transpile [
	self decoder node dispatchTo: self.
	^ self stream contents
]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> transpileChild: aDecoder [
	^ self copy
		decoder: aDecoder;
		transpile

]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> transpileChildren [
	self decoder children do: [ :child |
		self transpileChild: child
	].

]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> transpileChildrenWithDelimiter [
	self decoder children do: [ :child |
		self
			transpileChild: child;
			putStatementDelimiter;
			cr
	].

]

{ #category : #'private - code generation' }
SWMethodBodyTranspiler >> withoutMessageNestDo: aBlock [
	|nest|
	self halt; flag: #toRewrite.
	nest := messageNest.
	messageNest := 0.
	aBlock value.
	messageNest := nest
]
