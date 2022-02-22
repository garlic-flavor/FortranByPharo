"
resolve the class of a RBNode.
"
Class {
	#name : #SWDecoder,
	#superclass : #Object,
	#instVars : [
		'node',
		'result',
		'methodResult',
		'children',
		'pool',
		'slot',
		'haltList',
		'logger'
	],
	#category : #'SWFortranByPharo-Analyzer-Analyzer'
}

{ #category : #accessing }
SWDecoder class >> classTranspilerClass [
	^ SWClass
]

{ #category : #'as yet unclassified' }
SWDecoder class >> globalAccessKey [
	^ #globalAccess
]

{ #category : #'instance creation' }
SWDecoder class >> new: aNode with: operands [
	^ self new
		node: aNode;
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

{ #category : #accessing }
SWDecoder >> at: anObject [
	self result << anObject class
]

{ #category : #accessing }
SWDecoder >> atArray: anArrayNode [
	self result << Array
]

{ #category : #accessing }
SWDecoder >> atAssignTo: aLValue with: aRValue [
	self decodeChildren.
	self result << self children first result.
	self slot detect: [ :each | each name = aLValue name ] ifFound: [ :var |
		var << self result.		
	].

]

{ #category : #accessing }
SWDecoder >> atCascade: aCascadeNode [
	self resultIsLastChildsResult

]

{ #category : #accessing }
SWDecoder >> atCharacter: aCharacter [
	self result << aCharacter class
]

{ #category : #accessing }
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

{ #category : #accessing }
SWDecoder >> atFloat: aFloat [
	self result << aFloat class
]

{ #category : #accessing }
SWDecoder >> atInteger: anInteger [
	self result << anInteger class

]

{ #category : #accessing }
SWDecoder >> atMessage: aMessageNode [
	self decodeChildren.
	(aMessageNode selector = #declare:as: and: [ self children first result = SWType class ])ifTrue: [|name type|
		"A special case for type specification by source code."
		name := aMessageNode children second evaluate.
		type := aMessageNode children third evaluate.
		name = #return ifTrue: [
			self methodResult << (SWType new: type with: SWType userSpecifyingPriority)
		] ifFalse: [
			slot detect: [ :each | each name = name ] ifFound: [ :found | found << type ].
		].
		self result << SWType.
	] ifFalse: [
		self result << (self pool getResult: aMessageNode selector with: (self children collect: [ :each | each result ])).
	]
]

{ #category : #accessing }
SWDecoder >> atMethod: traverser [
	self decodeChildren.
	self methodResult << (SWVariable new: (self slot detect: [:each | each name = 'self' ]) value with: SWType receiverTypePriority)

]

{ #category : #accessing }
SWDecoder >> atNil [
	self result << UndefinedObject
]

{ #category : #accessing }
SWDecoder >> atPragma: aPragmaNode [
	(self haltList includes: #pragma) ifTrue: [ self halt ]
]

{ #category : #accessing }
SWDecoder >> atReturn: aReturnNode [
	self methodResult << self decodeChildren

]

{ #category : #accessing }
SWDecoder >> atSequence: aSequenceNode [
	self resultIsLastChildsResult

]

{ #category : #accessing }
SWDecoder >> atString: aString [
	self result << aString class
]

{ #category : #accessing }
SWDecoder >> atSymbol: aByteSymbol [
	self result << aByteSymbol class
]

{ #category : #accessing }
SWDecoder >> atVariable: aVariableNode [
	self result << (self slot detect: [ :each | each name = aVariableNode name ] ifNone: [
		self logger log: [ 'Access to global: ', aVariableNode name ].
		(self haltList includes: #globalAccess) ifTrue: [ self halt ].
		aVariableNode evaluate class
	]).

]

{ #category : #accessing }
SWDecoder >> children [

	^ children
]

{ #category : #accessing }
SWDecoder >> children: anObject [

	children := anObject
]

{ #category : #api }
SWDecoder >> decode [
	methodResult ifNil: [ methodResult := SWVariable new ].
	self pool.
	self node dispatchTo: self.
	^ methodResult
]

{ #category : #'as yet unclassified' }
SWDecoder >> decodeChildWith: aNode [
	^ self copy
		node: aNode;
		slot: self slot copy;
		decode;
		yourself.
]

{ #category : #'as yet unclassified' }
SWDecoder >> decodeChildren [
	self children: (OrderedCollection new: self node children size).
	self node children do: [ :child |
		self children addLast: (self decodeChildWith: child)
	].
	^ self children ifNotEmpty: [ self children last result ] ifEmpty: [ nil ]
]

{ #category : #initialization }
SWDecoder >> enableLogging [
	self logger enabled: true
]

{ #category : #accessing }
SWDecoder >> haltAt: aSymbol [
	self haltAt: aSymbol switch: true
]

{ #category : #accessing }
SWDecoder >> haltAt: key switch: aBoolean [
	aBoolean ifTrue: [
		self haltList add: key
	] ifFalse: [
		self haltList remove: key ifAbsent: [  ]
	]
]

{ #category : #'as yet unclassified' }
SWDecoder >> haltAtGlobalAccess [
	self haltAtGlobalAccess: true
]

{ #category : #'as yet unclassified' }
SWDecoder >> haltAtGlobalAccess: aBoolean [
	self haltAt: self class globalAccessKey switch: aBoolean
]

{ #category : #'as yet unclassified' }
SWDecoder >> haltAtPragma [
	self haltAtPragma: true
]

{ #category : #'as yet unclassified' }
SWDecoder >> haltAtPragma: aBoolean [
	self haltAt: self class pragmaKey switch: aBoolean
]

{ #category : #'as yet unclassified' }
SWDecoder >> haltAtUnresolvedSelector [
	self haltAtUnresolvedSelector: true
]

{ #category : #'as yet unclassified' }
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
SWDecoder >> methodResult [

	^ methodResult
]

{ #category : #accessing }
SWDecoder >> methodResult: anObject [

	methodResult := anObject
]

{ #category : #accessing }
SWDecoder >> node [

	^ node
]

{ #category : #accessing }
SWDecoder >> node: anObject [

	node := anObject
]

{ #category : #'as yet unclassified' }
SWDecoder >> operands: operands [
	|receiver|
	receiver := operands first value.
	self add: 'self' as: receiver.
	self add: 'super' as: receiver superclass.
	self node argumentNames  with: (operands copyFrom: 2 to: (operands size)) do: [ :name :type |
		self add: name as: type
	].
	self node temporaries do: [ :each |
		self add: each name as: nil
	].

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

{ #category : #accessing }
SWDecoder >> result [

	^ result ifNil: [ result := SWVariable new ]
]

{ #category : #accessing }
SWDecoder >> result: anObject [

	result := anObject
]

{ #category : #'as yet unclassified' }
SWDecoder >> resultIsLastChildsResult [
	self decodeChildren ifNotNil: [ :res |
		self result << res
	]
]

{ #category : #accessing }
SWDecoder >> slot [

	^ slot ifNil: [ slot := OrderedCollection new: (self node numArgs + self node temporaries size) ]
]

{ #category : #accessing }
SWDecoder >> slot: anObject [

	slot := anObject
]
