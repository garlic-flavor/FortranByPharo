"
resolve the class of a RBNode.
"
Class {
	#name : #SWDecoder,
	#superclass : #Object,
	#instVars : [
		'node',
		'slot',
		'result',
		'sender',
		'children',
		'pool',
		'haltList',
		'logger'
	],
	#category : #'SWFortranByPharo-Analyzer-Analyzer'
}

{ #category : #accessing }
SWDecoder class >> classTranspilerClass [
	self error; flag: #toRemove.
	^ SWClass
]

{ #category : #'as yet unclassified' }
SWDecoder class >> globalAccessKey [
	^ #globalAccess
]

{ #category : #'instance creation' }
SWDecoder class >> new: aMethod with: operands [
	^ self new
		method: aMethod;
		operands: operands;
		yourself
]

{ #category : #'as yet unclassified' }
SWDecoder class >> poolClass [
	^ SWPool
]

{ #category : #'as yet unclassified' }
SWDecoder class >> pragmaKey [
	^ #pragma
]

{ #category : #'as yet unclassified' }
SWDecoder class >> unresolvedSelectorKey [
	^ #unresolvedSelector

]

{ #category : #adding }
SWDecoder >> add: aName as: aType [
	self slot addLast: ((SWVariable new: aType)
		name: aName;
		yourself)
]

{ #category : #'dispatching-callback' }
SWDecoder >> at: anObject [
	self result << anObject class
]

{ #category : #'dispatching-callback' }
SWDecoder >> atArray: anArrayNode [
	self result << Array
]

{ #category : #'dispatching-callback' }
SWDecoder >> atAssignTo: aLValue with: aRValue [
	self decodeChildren.
	self result << self children first result.
	self slot detect: [ :each | each name = aLValue name ] ifFound: [ :var |
		var << self result.		
	].

]

{ #category : #accessing }
SWDecoder >> atBoolean: aBoolean [
	self result << aBoolean class
]

{ #category : #'dispatching-callback' }
SWDecoder >> atCascade: aCascadeNode [
	self result << self decodeChildren

]

{ #category : #'dispatching-callback' }
SWDecoder >> atCharacter: aCharacter [
	self result << aCharacter class
]

{ #category : #'dispatching-callback' }
SWDecoder >> atClosure: aBlockNode [
	|outerScope res|
	outerScope := self slot copy.
	aBlockNode argumentNames do: [ :name |
		self add: name as: nil
	].
	aBlockNode temporaries do: [ :temp |
		self add: temp name as: nil
	].
	res := ((SWContainer new: BlockClosure)
		elementType: self decodeChildren;
		yourself).
	self result << res.
	self slot: outerScope

]

{ #category : #'dispatching-callback' }
SWDecoder >> atFloat: aFloat [
	self result << aFloat class
]

{ #category : #'dispatching-callback' }
SWDecoder >> atInteger: anInteger [
	self result << anInteger class

]

{ #category : #'dispatching-callback' }
SWDecoder >> atMessage: aMessageNode [
	self decodeChildren.
	(aMessageNode selector = #declare:as: and: [ self children first result = SWType class ])ifTrue: [
		self userSpecifyVariableType: aMessageNode
	] ifFalse: [
		self atOrdinaryMessage: aMessageNode
	]
]

{ #category : #'dispatching-callback' }
SWDecoder >> atMethod: traverser [
	self decodeChildren.
	self sender hasResult ifFalse: [
		self sender result << self sender operands first
	]
]

{ #category : #'dispatching-callback' }
SWDecoder >> atNil [
	self result << UndefinedObject
]

{ #category : #private }
SWDecoder >> atOrdinaryMessage: aMessageNode [

	self sender: (self pool getSender: aMessageNode selector with: (self children collect: [ :each | each result ])).
	self result << self sender result
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
SWDecoder >> atPragma: aPragmaNode [
	(self haltList includes: self class pragmaKey) ifTrue: [ self halt ]
]

{ #category : #'dispatching-callback' }
SWDecoder >> atReturn: aReturnNode [
	self sender result << (self result << self decodeChildren)

]

{ #category : #'dispatching-callback' }
SWDecoder >> atSequence: aSequenceNode [
	self result << self decodeChildren

]

{ #category : #'dispatching-callback' }
SWDecoder >> atString: aString [
	self result << aString class
]

{ #category : #'dispatching-callback' }
SWDecoder >> atSymbol: aByteSymbol [
	self result << aByteSymbol class
]

{ #category : #'dispatching-callback' }
SWDecoder >> atVariable: aVariableNode [

	self result << (self slot detect: [ :each | each name = aVariableNode name ] ifNone: [
		self logger log: [ 'Access to global: ', aVariableNode name ].
		(self haltList includes: #globalAccess) ifTrue: [ self halt ].
		aVariableNode evaluate class
	]).

]

{ #category : #accessing }
SWDecoder >> children [

	^ children ifNil: [
		children := OrderedCollection new: self node children size
	]
]

{ #category : #accessing }
SWDecoder >> children: anObject [

	children := anObject
]

{ #category : #api }
SWDecoder >> decode [
	self pool.
	self node dispatchTo: self.

]

{ #category : #private }
SWDecoder >> decodeChild: aNode [
	^ self class new
		node: aNode;
		sender: self sender;
		slot: self slot copy;
		pool: self pool;
		haltList: self haltList;
		logger: self logger;
		decode;
		yourself.
]

{ #category : #private }
SWDecoder >> decodeChildren [
	self node children do: [ :child |
		self children addLast: (self decodeChild: child)
	].
	^ self children ifNotEmpty: [ self children last result ] ifEmpty: [ nil ]
]

{ #category : #modifying }
SWDecoder >> enableLogging [
	self logger enabled: true
]

{ #category : #modifying }
SWDecoder >> haltAt: aSymbol [
	self haltAt: aSymbol switch: true
]

{ #category : #modifying }
SWDecoder >> haltAt: key switch: aBoolean [
	aBoolean ifTrue: [
		self haltList add: key
	] ifFalse: [
		self haltList remove: key ifAbsent: [  ]
	]
]

{ #category : #modifying }
SWDecoder >> haltAtGlobalAccess [
	self haltAtGlobalAccess: true
]

{ #category : #modifying }
SWDecoder >> haltAtGlobalAccess: aBoolean [
	self haltAt: self class globalAccessKey switch: aBoolean
]

{ #category : #modifying }
SWDecoder >> haltAtPragma [
	self haltAtPragma: true
]

{ #category : #modifying }
SWDecoder >> haltAtPragma: aBoolean [
	self haltAt: self class pragmaKey switch: aBoolean
]

{ #category : #modifying }
SWDecoder >> haltAtUnresolvedSelector [
	self haltAtUnresolvedSelector: true
]

{ #category : #modifying }
SWDecoder >> haltAtUnresolvedSelector: aBoolean [
	self haltAt: self class unresolvedSelectorKey switch: aBoolean

]

{ #category : #accessing }
SWDecoder >> haltList [

	^ haltList ifNil: [ haltList := Set new ]
]

{ #category : #accessing }
SWDecoder >> haltList: anObject [

	haltList := anObject
]

{ #category : #accessing }
SWDecoder >> logger [

	^ logger ifNil: [ logger := SWLogger new ]
]

{ #category : #accessing }
SWDecoder >> logger: anObject [

	logger := anObject
]

{ #category : #accessing }
SWDecoder >> method [
	^ self sender method
]

{ #category : #accessing }
SWDecoder >> method: aMethod [
	self sender method: aMethod.
	self node: aMethod sourceNode.
]

{ #category : #accessing }
SWDecoder >> node [

	^ node
]

{ #category : #accessing }
SWDecoder >> node: anObject [

	node := anObject
]

{ #category : #api }
SWDecoder >> operands: operands [
	self sender operands: operands.
	self readySlot.

]

{ #category : #accessing }
SWDecoder >> pool [

	^ pool ifNil: [
		pool := self class poolClass new
			owner: self;
			yourself
	]
]

{ #category : #accessing }
SWDecoder >> pool: anObject [

	pool := anObject
]

{ #category : #'as yet unclassified' }
SWDecoder >> readySlot [
	|receiver|
	receiver := self sender operands first value.
	self add: 'self' as: receiver.
	self add: 'super' as: receiver superclass.
	self node argumentNames  with: (self sender operands copyFrom: 2 to: (self sender operands size)) do: [ :name :type |
		self add: name as: type
	].
	self node temporaries do: [ :each |
		self add: each name as: nil
	].

]

{ #category : #accessing }
SWDecoder >> receiverClass [
	^ self sender receiverClass
]

{ #category : #accessing }
SWDecoder >> result [

	^ result ifNil: [ result := SWVariable new ]
]

{ #category : #accessing }
SWDecoder >> result: anObject [

	result := anObject
]

{ #category : #accessing }
SWDecoder >> sender [

	^ sender ifNil: [ sender := SWSender new ]
]

{ #category : #accessing }
SWDecoder >> sender: anObject [

	sender := anObject.
	
]

{ #category : #accessing }
SWDecoder >> slot [

	^ slot ifNil: [ slot := OrderedCollection new: (self node numArgs + self node temporaries size) ]
]

{ #category : #accessing }
SWDecoder >> slot: anObject [

	slot := anObject
]

{ #category : #private }
SWDecoder >> userSpecifyVariableType: aNode [
	|name type|
	"A special case for type specification by source code."
	name := aNode children second evaluate.
	type := aNode children third evaluate.
	name = #return ifTrue: [
		self sender result << (SWType new: type with: SWType userSpecifyingPriority)
	] ifFalse: [
		slot detect: [ :each | each name = name ] ifFound: [ :found | found << type ].
	].
	self result << SWType.
]
