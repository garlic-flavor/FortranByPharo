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
		'calleeGenerator'
	],
	#category : #'SWFortranByPharo-Transpiler-Common'
}

{ #category : #constants }
SWMethodBodyTranspiler class >> mangleClass [
	^ self subclassResponsibility 
]

{ #category : #utils }
SWMethodBodyTranspiler class >> messageTranspilerMethodNameFor: aSelector [
	^ ((self mangleClass safeSelectorNameOf: aSelector), 'For:With:') asSymbol
]

{ #category : #utils }
SWMethodBodyTranspiler class >> search: selector in: aClass [
	aClass ifNil: [ ^ nil ].

	^ aClass methodDict at: selector ifAbsent: [
			self search: selector in: aClass superclass
	]

]

{ #category : #utils }
SWMethodBodyTranspiler class >> uniqueMessageTranspilerNameFor: aSelector for: type [
	^ (String streamContents: [ :s |
		s << type; <<  '_'; << (self mangleClass safeSelectorNameOf: aSelector); << 'With:Using:'
	]) asSymbol
	

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> << anObject [
	self stream log.
	anObject transpileUsing: self

]

{ #category : #accessing }
SWMethodBodyTranspiler >> calleeGenerator [

	^ calleeGenerator ifNil: [
		calleeGenerator := [ :transpiler :aNode ||transpilerSelector|
			transpilerSelector := transpiler class mangleClass selectorForTranspilerOf: aNode selector.
			(transpiler respondsTo: transpilerSelector) ifTrue: [
				transpiler perform: transpilerSelector with: aNode
			] ifFalse: [
				transpiler putOrdinaryMessage: aNode
			]
		]
	]
]

{ #category : #accessing }
SWMethodBodyTranspiler >> calleeGenerator: anObject [

	calleeGenerator := anObject
]

{ #category : #'private - utilities' }
SWMethodBodyTranspiler >> classOf: aNode [
	self error; flag: #toRemove.
	aNode class = RBVariableNode ifTrue: [
		^ aNode name first isUppercase ifTrue: [
			(Smalltalk globals at: aNode name asSymbol) class
		] ifFalse: [
			(self variableInfoOf: aNode name) type
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

{ #category : #'private - code generation' }
SWMethodBodyTranspiler >> decMessageNest [
	messageNest push: { 0. messageNest pop - 1 } max.
	0 < messageNest top ifTrue: [ self put: ')' ].

]

{ #category : #accessing }
SWMethodBodyTranspiler >> filename [
	^ self method methodClass instanceSide name, self selector
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

{ #category : #'private - code generation' }
SWMethodBodyTranspiler >> incMessageNest [
	messageNest push: (messageNest pop + 1).
	1 < messageNest top ifTrue: [ self put: '(' ].
]

{ #category : #initialization }
SWMethodBodyTranspiler >> initialize [
	super initialize.
	messageNest := Stack newFrom: { 0 }.
]

{ #category : #'public API' }
SWMethodBodyTranspiler >> logging: trueOrFalse [
	self stream logging: trueOrFalse
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> opEqual_For: receiver With: arguments [
	self stream log: [ receiver asString, ' == ', (arguments at: 1) asString ].
	self
		<< receiver;
		put: ' == ';
		<< (arguments at: 1).

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> put: anObject [
	self stream put: anObject asString
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putArguments: arguments [
	self stream log.
	self put: '('.
	arguments do: [ :each |
		self << each
	] separatedBy: [
		self put: ', '
	].
	self put: ')'

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
	self calleeGenerator cull: self cull: aNode

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
	self stream
		put: 'import {'.
	anArray do: [ :each |
		self stream put: each asString
	] separatedBy: [
		self stream put: ', '
	].
	self stream
		put: '} from ';
		put: aSource asString
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
	t2 := (self messages at: aNode)
		stream: self stream;
		yourself.
	t2 messages addAll: self messages.
	t2 putCallee: aNode.
	self decMessageNest
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putMessage: aNode withReceiver: aRNode [
	self stream log: [ aRNode asString, ' >> ', aNode selector asString ].
	self incMessageNest.
	(self messages at: aNode)
		stream: self stream;
		messages: self messages;
		putCallee: (aNode copy
			receiver: aRNode
			yourself).
	self decMessageNest

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putOrdinaryMessage: aNode [
	self stream log.

	self
		<< aNode receiver;
		putClassAccessor;
		put: aNode selector;
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
		<< value.
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putSelf [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putSequence: aSequence [
	aSequence statements do: [ :each |
		self putStatement: each
	]
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putSequenceWithReturn: aSequence [
	aSequence statements doWithIndex: [ :each :index |
		index < aSequence statements size ifTrue: [
			self putStatement: each
		] ifFalse: [
			self
				putReturn: each;
				putStatementDelimiter
		]
	]
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putStatement: aStatement [
	self << aStatement.
	aStatement class = RBCascadeNode ifTrue: [ ^ self ].
	self
		putStatementDelimiter;
		cr

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putStatementDelimiter [
	^ self subclassResponsibility 
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
		self putSelf
	] ifFalse: [
		self put: aVariableNode name
	]
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
SWMethodBodyTranspiler >> stream [

	^ stream ifNil: [ stream := SWTranspilerStream new ]
]

{ #category : #accessing }
SWMethodBodyTranspiler >> stream: anObject [

	stream := anObject
]

{ #category : #'public API' }
SWMethodBodyTranspiler >> transpile [
	self stream log.
	self locals do: [ :each | self putVariableDeclarationOf: each ].
	self putSequence: self method sourceNode body.
	^ self stream contents
]

{ #category : #accessing }
SWMethodBodyTranspiler >> type [

	^ type
]

{ #category : #accessing }
SWMethodBodyTranspiler >> type: anObject [

	type := anObject
]
