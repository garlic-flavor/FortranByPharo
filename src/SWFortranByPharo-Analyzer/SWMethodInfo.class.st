"
resolve the class of a RBNode.
"
Class {
	#name : #SWMethodInfo,
	#superclass : #Object,
	#instVars : [
		'node',
		'slot',
		'result',
		'messageInfo',
		'children',
		'pool'
	],
	#category : #'SWFortranByPharo-Analyzer-Analyzer'
}

{ #category : #'instance creation' }
SWMethodInfo class >> new: aMethod with: operands [
	^ self new
		method: aMethod;
		operands: operands;
		yourself
]

{ #category : #adding }
SWMethodInfo >> addToSlot: aName as: aType [
	self slot addLast: ((SWVariable new: aType)
		name: aName;
		yourself)
]

{ #category : #'dispatching-callback' }
SWMethodInfo >> at: anObject [
	self result << anObject class
]

{ #category : #'dispatching-callback' }
SWMethodInfo >> atArray: anArrayNode [
	self result << Array
]

{ #category : #'dispatching-callback' }
SWMethodInfo >> atAssignTo: aLValue with: aRValue [
	self decodeChildren.
	self result << self children first result.
	self slot detect: [ :each | each name = aLValue name ] ifFound: [ :var |
		var << self result.		
	].

]

{ #category : #accessing }
SWMethodInfo >> atBoolean: aBoolean [
	self result << aBoolean class
]

{ #category : #'dispatching-callback' }
SWMethodInfo >> atCascade: aCascadeNode [
	self result << self decodeChildren

]

{ #category : #'dispatching-callback' }
SWMethodInfo >> atCharacter: aCharacter [
	self result << aCharacter class
]

{ #category : #'dispatching-callback' }
SWMethodInfo >> atClosure: aBlockNode [
	|outerScope res|
	outerScope := self slot copy.
	aBlockNode argumentNames do: [ :name |
		self addToSlot: name as: nil
	].
	aBlockNode temporaries do: [ :temp |
		self addToSlot: temp name as: nil
	].
	res := ((SWContainer new: BlockClosure)
		elementType: self decodeChildren;
		yourself).
	self result << res.
	self slot: outerScope

]

{ #category : #'dispatching-callback' }
SWMethodInfo >> atFloat: aFloat [
	self result << aFloat class
]

{ #category : #'dispatching-callback' }
SWMethodInfo >> atInteger: anInteger [
	self result << anInteger class

]

{ #category : #'dispatching-callback' }
SWMethodInfo >> atMessage: aMessageNode [
	self decodeChildren.
	(aMessageNode selector = #declare:as: and: [ self children first result = SWType class ])ifTrue: [
		self userSpecifyVariableType: aMessageNode
	] ifFalse: [
		self atOrdinaryMessage: aMessageNode
	]
]

{ #category : #'dispatching-callback' }
SWMethodInfo >> atMethod: traverser [
	self decodeChildren.
	self messageInfo hasResult ifFalse: [
		self messageInfo result << self messageInfo operands first
	]
]

{ #category : #'dispatching-callback' }
SWMethodInfo >> atNil [
	self result << UndefinedObject
]

{ #category : #private }
SWMethodInfo >> atOrdinaryMessage: aMessageNode [

	self messageInfo: (self pool getMessageInfo: aMessageNode selector with: (self children collect: [ :each | each result ])).
	self result << self messageInfo result
"
	operands := self children collect: [ :each | each result ].		
	method := self class search: aMessageNode selector in: operands first value.
	self sender: (SWSender new
		operands: operands;
		method: method;
		yourself).
	method ifNil: [
		self logger log: [ 'An unknown method detected: ', aMessageNode selector ].
		(self haltList includes: self class unresolvedSelectorKey)  ifTrue: [ self halt ].
	] ifNotNil: [
		self result << (self pool getResult: self sender).
	]
"

]

{ #category : #'dispatching-callback' }
SWMethodInfo >> atPragma: aPragmaNode [
	self pool atPragma
]

{ #category : #'dispatching-callback' }
SWMethodInfo >> atReturn: aReturnNode [
	self messageInfo result << (self result << self decodeChildren)

]

{ #category : #'dispatching-callback' }
SWMethodInfo >> atSequence: aSequenceNode [
	self result << self decodeChildren

]

{ #category : #'dispatching-callback' }
SWMethodInfo >> atString: aString [
	self result << aString class
]

{ #category : #'dispatching-callback' }
SWMethodInfo >> atSymbol: aByteSymbol [
	self result << aByteSymbol class
]

{ #category : #'dispatching-callback' }
SWMethodInfo >> atVariable: aVariableNode [

	self result << (self slot detect: [ :each | each name = aVariableNode name ] ifNone: [
		self pool atGlobalAccess.
		aVariableNode evaluate class
	]).

]

{ #category : #accessing }
SWMethodInfo >> children [

	^ children
]

{ #category : #accessing }
SWMethodInfo >> children: anObject [

	children := anObject
]

{ #category : #api }
SWMethodInfo >> decode [
	self node dispatchTo: self.

]

{ #category : #private }
SWMethodInfo >> decodeChild: aNode [
	^ self class new
		node: aNode;
		messageInfo: self messageInfo;
		slot: self slot copy;
		pool: self pool;
		decode;
		yourself.
]

{ #category : #private }
SWMethodInfo >> decodeChildren [
	self children: (self node children collect: [ :child |
		self decodeChild: child
	]).
	^ self children ifNotEmpty: [ self children last result ] ifEmpty: [ nil ]
]

{ #category : #accessing }
SWMethodInfo >> messageInfo [

	^ messageInfo ifNil: [ messageInfo := SWMessageInfo new ]
]

{ #category : #accessing }
SWMethodInfo >> messageInfo: anObject [

	messageInfo := anObject
]

{ #category : #accessing }
SWMethodInfo >> method [
	^ self messageInfo method
]

{ #category : #accessing }
SWMethodInfo >> method: aMethod [
	self messageInfo method: aMethod.

]

{ #category : #accessing }
SWMethodInfo >> node [

	^ node ifNil: [ node := self messageInfo method sourceNode ]
]

{ #category : #accessing }
SWMethodInfo >> node: anObject [

	node := anObject
]

{ #category : #api }
SWMethodInfo >> operands: operands [
	self messageInfo operands: operands.
	self readySlot.

]

{ #category : #accessing }
SWMethodInfo >> pool [

	^ pool
]

{ #category : #accessing }
SWMethodInfo >> pool: anObject [

	pool := anObject
]

{ #category : #private }
SWMethodInfo >> readySlot [
	|receiver|
	receiver := self messageInfo operands first value.
	self addToSlot: 'self' as: receiver.
	self addToSlot: 'super' as: receiver superclass.
	self node argumentNames  with: (self messageInfo operands allButFirst) do: [ :name :type |
		self addToSlot: name as: type
	].
	self node temporaries do: [ :each |
		self addToSlot: each name as: nil
	].

]

{ #category : #accessing }
SWMethodInfo >> receiverClass [
	^ self messageInfo receiverClass
]

{ #category : #accessing }
SWMethodInfo >> result [

	^ result ifNil: [ result := SWValue new ]
]

{ #category : #accessing }
SWMethodInfo >> result: anObject [

	result := anObject
]

{ #category : #accessing }
SWMethodInfo >> slot [

	^ slot ifNil: [ slot := OrderedCollection new: (self node numArgs + self node temporaries size) ]
]

{ #category : #accessing }
SWMethodInfo >> slot: anObject [

	slot := anObject
]

{ #category : #private }
SWMethodInfo >> userSpecifyVariableType: aNode [
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
