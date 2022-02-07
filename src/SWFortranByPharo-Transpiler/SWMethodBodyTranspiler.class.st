"
I transpile a method of Pharo class.
"
Class {
	#name : #SWMethodBodyTranspiler,
	#superclass : #SWStackAnalyzer,
	#instVars : [
		'stream',
		'type',
		'messageNest',
		'senderGenerator',
		'generator'
	],
	#category : #'SWFortranByPharo-Transpiler-Common'
}

{ #category : #constants }
SWMethodBodyTranspiler class >> mangleClass [
	^ self subclassResponsibility 
]

{ #category : #utils }
SWMethodBodyTranspiler class >> messageTranspilerMethodNameFor: aSelector [
	self error; flag: #toRemove.
	^ ((self mangleClass safeSelectorNameOf: aSelector), 'For:With:') asSymbol
]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler class >> methodDefinitionTranspilerClass [ 
	^ self subclassResponsibility
]

{ #category : #utils }
SWMethodBodyTranspiler class >> search: selector in: aClass [
	self error; flag: #toRemove.
	aClass ifNil: [ ^ nil ].

	^ aClass methodDict at: selector ifAbsent: [
			self search: selector in: aClass superclass
	]

]

{ #category : #accessing }
SWMethodBodyTranspiler class >> senderTranspilerClass [
	^ SWSenderTranspiler
]

{ #category : #utils }
SWMethodBodyTranspiler class >> uniqueMessageTranspilerNameFor: aSelector for: type [
	self error; flag: #toRemove.
	^ (String streamContents: [ :s |
		s << type; <<  '_'; << (self mangleClass safeSelectorNameOf: aSelector); << 'With:Using:'
	]) asSymbol
	

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> << anObject [
	self stream log.
	anObject transpileUsing: self

]

{ #category : #'private - utilities' }
SWMethodBodyTranspiler >> classOf: aNode [
	self error; flag: #toRemove.
	aNode class = RBVariableNode ifTrue: [
		^ aNode name first isUppercase ifTrue: [
			(Smalltalk globals at: aNode name asSymbol) class
		] ifFalse: [
			(self getVariableInfoOf: aNode name) type
		]
	].

	aNode class = RBLiteralValueNode ifTrue: [
		^ aNode value class
	].

	aNode class = RBMessageNode ifTrue: [
		^ (self messages at: aNode) return type
	].

	self error: 'to implement'.
	self flag: #toImplement.
]

{ #category : #'private - utilities' }
SWMethodBodyTranspiler >> classSideClassOf: aNode [
self error; flag: #toRemove.
	^ aNode class = RBVariableNode ifTrue: [
		aNode variable value class classSide
	] ifFalse: [
		nil
	]
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> cr [
	self stream putLine
]

{ #category : #'code generation - protected' }
SWMethodBodyTranspiler >> decIndent [
	self stream decIndent
]

{ #category : #'private - code generation' }
SWMethodBodyTranspiler >> decMessageNest [
	messageNest := messageNest - 1.
	0 < messageNest ifTrue: [ self put: ')' ].

]

{ #category : #accessing }
SWMethodBodyTranspiler >> generator [
	^ generator ifNil: [ generator := [ :transpiler | |m|
		m := transpiler method.
		transpiler stream log.
		transpiler locals do: [ :each | self putVariableDeclarationOf: each ].
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

	generator := anObject
]

{ #category : #'private - testing' }
SWMethodBodyTranspiler >> hasOwnMessageTranspilerMethodOf: aSelector ifTrue: aBlock [
	|otms aMethod|
	self error; flag: #toRemove.
	otms := self class messageTranspilerMethodNameFor: aSelector.
	(aMethod := self class search: otms in: self class) ifNotNil: [
		aBlock value: [ :receiver :arguments |
			aMethod valueWithReceiver: self arguments: { receiver. arguments }
		]
	]

]

{ #category : #'private - testing' }
SWMethodBodyTranspiler >> ifUniqueMessageTranspilerExistsOn: receiver of: selector thenDo: aBlock [
	| receiverClassSideClass selectorName transpiler |
self error; flag: #toRemove.
	receiverClassSideClass := self classSideClassOf: receiver.
	selectorName := self class uniqueMessageTranspilerNameFor: selector for: self type.
	(transpiler := self class search: selectorName in: receiverClassSideClass) ifNotNil: [
		aBlock value: [ :arguments |
			transpiler valueWithReceiver: receiverClassSideClass arguments: { arguments. self }
		]
	].

]

{ #category : #'code generation - protected' }
SWMethodBodyTranspiler >> incIndent [
	self stream incIndent
]

{ #category : #'private - code generation' }
SWMethodBodyTranspiler >> incMessageNest [
	messageNest := messageNest + 1.
	1 < messageNest ifTrue: [ self put: '(' ].
]

{ #category : #'public API' }
SWMethodBodyTranspiler >> logging: trueOrFalse [
	self stream logging: trueOrFalse
]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> mangle: aName [
	^ self class mangleClass mangle: aName
]

{ #category : #accessing }
SWMethodBodyTranspiler >> messageNest [

	^ messageNest ifNil: [ messageNest := 0 ]
]

{ #category : #accessing }
SWMethodBodyTranspiler >> messageNest: anObject [

	messageNest := anObject
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> opEqual_For: receiver With: arguments [
	self stream log: [ receiver asString, ' == ', (arguments at: 1) asString ].
	self
		<< receiver;
		put: ' == ';
		<< (arguments at: 1).

]

{ #category : #'code generation - protected' }
SWMethodBodyTranspiler >> preventNewline [
	self stream preventNewline
]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> preventStatementDelimiter [
	self stream preventDelimiter
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> put: anObject [
	self stream put: anObject asString
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putArguments: arguments [
	self stream log.
	self
		put: '(';
		withoutMessageNestDo: [
			arguments do: [ :each |
				self << each
			] separatedBy: [
				self put: ', '
			]
		];
		put: ')'

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putArray: anArray [
	self stream log.
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
	self stream log: [ key asString, ' = ', value asString ].
	self
		<< key;
		put: ' = ';
		<< value

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putBlock: aBlockNode [
	self stream log.
	self
		put: '{';
		putSequence: aBlockNode body;
		put: '}'
]

{ #category : #accessing }
SWMethodBodyTranspiler >> putBlockAsExpression: aBlock [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWMethodBodyTranspiler >> putCallee: aNode [
	self stream log.
	self senderGenerator cull: self cull: aNode

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putCascade: aRBCascadeNode [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putCharacter: c [
	self stream log.

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
SWMethodBodyTranspiler >> putCode: code [
	^ self putCode: code with: {  }
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putCode: code with: anAssociationArray [
	"when a line in code ends with $\, the line continues to the next."
	|matcher leftPad escaped|
	self stream log.

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

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> putFilenameOn: aStream [
	aStream
		<< self receiverClass instanceSide name;
		<< self selector asCamelCase
]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> putIfFalse: aNode [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWMethodBodyTranspiler >> putIfTrue: aNode [
	^ self subclassResponsibility
]

{ #category : #accessing }
SWMethodBodyTranspiler >> putIfTrueIfFalse: aNode [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> putImport: anArray from: aSource [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putInteger: anInteger [
	self stream log.
	self put: anInteger asString
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putLine: anObject [
	self stream putLine: anObject asString
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putMessage: aNode [
	|t2|
	self stream log: [ aNode receiver asString, ' >> ', aNode selector asString ].
	self incMessageNest.

	self << (self senders at: aNode).
"
	t2 := (self messages at: aNode) asCallee
		messageNest: self messageNest + 1;
		messages: self messages;
		stack: self stack;
		classInfo: self classInfo;
		stream: self stream;
		yourself.

	t2 putCallee: aNode.
"
	self decMessageNest
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putMessage: aNode withReceiver: aRNode [
	|sender|
	self stream log: [ aRNode asString, ' >> ', aNode selector asString ].
	sender := (self senders at: aNode) copy.
	sender node: (aNode copy
		receiver: aRNode
		yourself).
	self << sender
]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> putNew: aNode [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> putOpBinary: aNode [
	self stream log.
	
	self
		<< aNode receiver;
		put: ' ';
		put: aNode selector;
		put: ' ';
		<< (aNode arguments at: 1)

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putOrdinaryCallee: aNode [
	self stream log.
	self 
		withoutMessageNestDo: [
			self << aNode receiver
		];
		putClassAccessor;
		put: (self class mangleClass mangle: self);
		putArguments: aNode arguments

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putOrdinaryMessage: aNode withReceiver: aRNode [
	self error; flag: #toRemove.

	self stream log.
	self << aRNode.
	aNode selector first isLetter ifTrue: [
		self
			putClassAccessor;
			put: (self class mangleClass mangle: (self messages at: aNode));
			putArguments: aNode arguments.
	] ifFalse: [
		self
			put: aNode selector;
			<< (aNode arguments at: 1)
	]


]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putParameters: anArray [
	self stream log.
	anArray do: [:each |
		self put: each asString
	] separatedBy: [
		self put: ', '
	]

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putReturn: value [
	self stream log.
	^ self
		put: 'return ';
		withoutMessageNestDo: [
			self << value
		]
]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> putReturnSelf [
	self putStatement: (RBReturnNode value: (RBVariableNode named: 'self'))
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putSelf [
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> putSelfDefinition [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putSequence: aSequence [
	self withoutMessageNestDo: [
		aSequence statements do: [ :each |
			self putStatement: each
		]
	]
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putSequenceWithReturn: aSequence [
	self withoutMessageNestDo: [
		aSequence statements doWithIndex: [ :each :index |
			(index < aSequence statements size or: [ each class = RBReturnNode ]) ifTrue: [
				self putStatement: each
			] ifFalse: [
				self
					putReturn: each;
					putStatementDelimiter;
					cr
			]
		]
	]
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putStatement: aStatement [
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
	self stream log.
	self
		put: '"';
		put: aString;
		put: '"'.
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putSymbol: aByteSymbol [
	self stream
		put: '"';
		put: aByteSymbol asString;
		put: '"'
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putVariable: aVariableNode [
	self stream log: aVariableNode name.
	aVariableNode name = #self ifTrue: [
		^ self putSelf
	].
	self getVariableInfoOf: aVariableNode name ifPresent: [ :vi |
		(vi owner class inheritsFrom: SWClass) ifTrue: [
			self
				putSelf;
				putClassAccessor;
				put: '_'
		]
	].
	self put: aVariableNode name

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putVariableDeclarationOf: aVariableInfo [
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> putYourself: aNode [
	^ self subclassResponsibility 
]

{ #category : #'private - code generation' }
SWMethodBodyTranspiler >> selectTranspiler: aNode withReceiver: aRNode [
	self error; flag: #toRemove.
	self stream log: [ aNode receiver asString, ' >> ', aNode selector asString ].
	self ifUniqueMessageTranspilerExistsOn: aRNode of: aNode selector thenDo: [ :proc |
		^ proc value: aNode arguments
	].
	self hasOwnMessageTranspilerMethodOf: aNode selector ifTrue: [ :proc |
		^ proc with: aRNode with: aNode arguments
	].
	^ self putOrdinaryMessage: aNode withReceiver: aRNode

]

{ #category : #accessing }
SWMethodBodyTranspiler >> senderGenerator [
	self error; flag: #toRemove.
	^ senderGenerator ifNil: [
		senderGenerator := [ :transpiler :aNode ||transpilerSelector|
			transpilerSelector := transpiler class mangleClass selectorForTranspilerOf: aNode selector.
			(transpiler respondsTo: transpilerSelector) ifTrue: [
				transpiler perform: transpilerSelector with: aNode
			] ifFalse: [
				transpiler putOrdinaryCallee: aNode
			]
		]
	]
]

{ #category : #accessing }
SWMethodBodyTranspiler >> senderGenerator: anObject [
	self error; flag: #toRemove.
	senderGenerator := anObject
]

{ #category : #accessing }
SWMethodBodyTranspiler >> stream [

	^ stream ifNil: [
		stream := SWTranspilerStream new
			logger: self logger;
			yourself
	]
]

{ #category : #accessing }
SWMethodBodyTranspiler >> stream: anObject [

	stream := anObject.
	self logger: anObject logger
]

{ #category : #'public API' }
SWMethodBodyTranspiler >> transpile [
	self generator value: self.
	^ self stream contents
]

{ #category : #accessing }
SWMethodBodyTranspiler >> type [
self error; flag: #toRemove.
	^ type
]

{ #category : #accessing }
SWMethodBodyTranspiler >> type: anObject [

	type := anObject
]

{ #category : #enumerating }
SWMethodBodyTranspiler >> withoutMessageNestDo: aBlock [
	|nest|
	nest := messageNest.
	messageNest := 0.
	aBlock value.
	messageNest := nest
]
