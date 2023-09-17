"
this resolves the class of the result of a RBNode.
"
Class {
	#name : #SWExpression,
	#superclass : #Object,
	#instVars : [
		'node',
		'slot',
		'result',
		'messageInfo',
		'arguments',
		'locals',
		'children',
		'pool'
	],
	#category : #'SWFortranByPharo-Analyzer-Analyzer'
}

{ #category : #modifying }
SWExpression >> addToSlot: aName as: aType [
	^ self slot addLast: (SWVariable new
		<< aType;
		name: aName;
		yourself)
]

{ #category : #accessing }
SWExpression >> arguments [

	^ arguments ifNil: [
		arguments := self node argumentNames collect: [ :name |
			SWVariable named: name
		]
	]
]

{ #category : #accessing }
SWExpression >> arguments: anObject [

	arguments := anObject
]

{ #category : #private }
SWExpression >> assignTo: aLValue with: aRValue [
	self decodeChildren.
	self result << self children first result.
	self slot detect: [ :each | each name = aLValue name ] ifFound: [ :var |
		var << self result.		
	].

]

{ #category : #'dispatching-callback' }
SWExpression >> at: anObject [
	self result << anObject class
]

{ #category : #'dispatching-callback' }
SWExpression >> atArray: anArrayNode [
	self decodeChildren.
	self flag: #toImplement.
	self result << Array
]

{ #category : #'dispatching-callback' }
SWExpression >> atAssign: anAssignNode [
	self assignTo: anAssignNode variable with: anAssignNode value

]

{ #category : #'dispatching-callback' }
SWExpression >> atBlock: aBlockNode [

	self slot: self slot copy.
	self readyArgsAndLocals.
	self result << ((SWContainer new: BlockClosure)
		elementType: self decodeStatements;
		yourself)


]

{ #category : #'dispatching-callback' }
SWExpression >> atBoolean: aBoolean [
	self result << aBoolean class
]

{ #category : #'dispatching-callback' }
SWExpression >> atCascade: aCascadeNode [
	self result << self decodeChildren

]

{ #category : #'dispatching-callback' }
SWExpression >> atCharacter: aCharacter [
	self result << aCharacter class
]

{ #category : #'dispatching-callback' }
SWExpression >> atFloat: aFloat [
	self result << aFloat class
]

{ #category : #'dispatching-callback' }
SWExpression >> atInteger: anInteger [
	self result << anInteger class

]

{ #category : #'dispatching-callback' }
SWExpression >> atLiteralArray: aLiteralArrayNode [
	self atArray: aLiteralArrayNode
]

{ #category : #'dispatching-callback' }
SWExpression >> atLiteralValue: aLiteral [
	aLiteral value ifNotNil: [ :val |
		val dispatchTo: self
	] ifNil: [
		self result << UndefinedObject
	]

]

{ #category : #'dispatching-callback' }
SWExpression >> atMessage: aMessageNode [
	self decodeChildren.
	(aMessageNode selector = #declare:as: and: [ self children first result = SWType class ])ifTrue: [
		self userSpecifyVariableType: aMessageNode
	].
	(self pool haltList includes: aMessageNode selector) ifTrue: [ self halt ].
	self messageInfo: (self pool decode: aMessageNode selector with: (self children collect: [ :each | each result ])) messageInfo.
	self result << self messageInfo result

]

{ #category : #'dispatching-callback' }
SWExpression >> atMethod: aMethodNode [
	self decodeStatements.
	self messageInfo hasResult ifFalse: [
		self messageInfo result << self messageInfo operands first
	]
]

{ #category : #'dispatching-callback' }
SWExpression >> atPragma: aPragmaNode [
	self pool atPragma
]

{ #category : #'dispatching-callback' }
SWExpression >> atReturn: aReturnNode [
	self messageInfo result << (self result << self decodeChildren)

]

{ #category : #'dispatching-callback' }
SWExpression >> atSequence: aSequenceNode [
	self result << self decodeChildren

]

{ #category : #'dispatching-callback' }
SWExpression >> atString: aString [
	self result << aString class
]

{ #category : #'dispatching-callback' }
SWExpression >> atSymbol: aByteSymbol [
	self result << aByteSymbol class
]

{ #category : #'dispatching-callback' }
SWExpression >> atVariable: aVariableNode [

	self result << (self slot detect: [ :each | each name = aVariableNode name ] ifNone: [
		self pool atGlobalAccess.
		aVariableNode evaluate class
	]).

]

{ #category : #accessing }
SWExpression >> children [

	^ children
]

{ #category : #accessing }
SWExpression >> children: anObject [

	children := anObject
]

{ #category : #testing }
SWExpression >> containsAsMember: aName [
	self slot do: [ :each |
		each name = 'self' ifTrue: [ ^ false ].
		each name = aName ifTrue: [ ^ true ]
	].
	^ false
]

{ #category : #api }
SWExpression >> decode [
	self node dispatchTo: self.

]

{ #category : #private }
SWExpression >> decodeChild: aNode [
	^ self copy
		node: aNode;
		result: nil;
		children: nil;
		decode;
		yourself.
]

{ #category : #private }
SWExpression >> decodeChildren [
	self children: (self node children collect: [ :child |
		self decodeChild: child
	]).
	^ self children ifNotEmpty: [ self children last result ] ifEmpty: [ nil ]
]

{ #category : #private }
SWExpression >> decodeStatements [
	self children: (self node statements collect: [ :child |
		self decodeChild: child
	]).
	^ self children ifNotEmpty: [ self children last result ] ifEmpty: [ nil ]
]

{ #category : #accessing }
SWExpression >> expression [
	^ self
]

{ #category : #accessing }
SWExpression >> locals [

	^ locals ifNil: [
		locals := self node temporaryNames collect: [ :name |
			SWVariable named: name
		]
	]
]

{ #category : #accessing }
SWExpression >> locals: anObject [

	locals := anObject
]

{ #category : #accessing }
SWExpression >> messageInfo [

	^ messageInfo ifNil: [ messageInfo := self pool class messageInfoClass new ]
]

{ #category : #accessing }
SWExpression >> messageInfo: anObject [

	messageInfo := anObject
]

{ #category : #accessing }
SWExpression >> method [
	^ self messageInfo method
]

{ #category : #accessing }
SWExpression >> method: aMethod [
	self messageInfo method: aMethod.

]

{ #category : #accessing }
SWExpression >> node [

	^ node ifNil: [ node := self messageInfo method sourceNode ]
]

{ #category : #accessing }
SWExpression >> node: anObject [

	node := anObject
]

{ #category : #modifying }
SWExpression >> operands: operands [

	self messageInfo operands: operands.
	self readySlot.

]

{ #category : #accessing }
SWExpression >> pool [

	^ pool
]

{ #category : #accessing }
SWExpression >> pool: anObject [

	pool := anObject
]

{ #category : #private }
SWExpression >> readyArgsAndLocals [
	self slot
		addAllLast: self arguments;
		addAllLast: self locals
	
]

{ #category : #private }
SWExpression >> readySlot [
	|receiver|
	receiver := self messageInfo operands first.
	self addToSlot: 'self' as: receiver;
		addToSlot: 'super' as: receiver superclass;
		readyArgsAndLocals.
	self arguments with: self messageInfo operands allButFirst do: [ :arg :type |
		arg << type
	].

]

{ #category : #accessing }
SWExpression >> receiverClass [
	^ self messageInfo receiverClass
]

{ #category : #accessing }
SWExpression >> result [

	^ result ifNil: [ result := SWValue new ]
]

{ #category : #accessing }
SWExpression >> result: anObject [

	result := anObject
]

{ #category : #accessing }
SWExpression >> senderInfo [
	^ messageInfo
]

{ #category : #accessing }
SWExpression >> slot [

	^ slot ifNil: [ slot := OrderedCollection new ]
]

{ #category : #accessing }
SWExpression >> slot: anObject [

	slot := anObject
]

{ #category : #private }
SWExpression >> userSpecifyVariableType: aNode [
	|name type|
	"A special case for type specification by source code."
	name := aNode children second evaluate.
	type := aNode children third evaluate.
	name = #return ifTrue: [
		self messageInfo result << (SWType new: type with: SWType userSpecifyingPriority)
	] ifFalse: [
		slot detect: [ :each | each name = name ] ifFound: [ :found | found << type ].
	].
	self result << SWType.
]
