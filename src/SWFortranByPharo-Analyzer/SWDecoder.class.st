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

{ #category : #'instance creation' }
SWDecoder class >> new: aNode with: operands [
	^ self new
		node: aNode;
		operands: operands;
		yourself
]

{ #category : #adding }
SWDecoder >> add: aName as: aType [
	self slot addLast: ((SWVariableType new: aType)
		name: aName;
		yourself)
]

{ #category : #accessing }
SWDecoder >> atAssignTo: aLValue with: aRValue [

	self result << self children first result
]

{ #category : #accessing }
SWDecoder >> atInteger: anInteger [
	self result << anInteger class

]

{ #category : #accessing }
SWDecoder >> atMessage: aMessageNode [
	self halt.
]

{ #category : #accessing }
SWDecoder >> atMethod: traverser [
	self methodResult << self result
]

{ #category : #accessing }
SWDecoder >> atReturn: aReturnNode [
	self methodResult << self result
]

{ #category : #accessing }
SWDecoder >> atSequence: aSequenceNode [
]

{ #category : #accessing }
SWDecoder >> atVariable: aVariableNode [
	self result << (self slot detect: [ :each | each name = aVariableNode name ] ifNone: [
		Smalltalk globals at: aVariableNode name
	])
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
	methodResult  ifNil: [ methodResult := SWVariableType new: self slot first value with: SWType receiverTypePriority ].
	self children: (OrderedCollection new: self node children size).
	self node children do: [ :child |
		self children addLast: (self decodeChildDecoderWith: child)
	].
	self children isNotEmpty ifTrue: [
		self result << self children last result
	].
	self node traverseUsing: self.

]

{ #category : #'as yet unclassified' }
SWDecoder >> decodeChildDecoderWith: aNode [
	^ self copy
		node: aNode;
		slot: self slot copy;
		decode;
		yourself.
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
	(self node argumentNames copyWithFirst: 'self') with: operands do: [ :name :type |
		self add: name as: type
	].
	self node temporaries do: [ :each |
		self add: each name as: nil
	]
]

{ #category : #accessing }
SWDecoder >> pool [

	^ pool ifNil: [
		pool := SWPool new
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

	^ result ifNil: [ result := SWVariableType new ]
]

{ #category : #accessing }
SWDecoder >> result: anObject [

	result := anObject
]

{ #category : #accessing }
SWDecoder >> slot [

	^ slot ifNil: [ slot := OrderedCollection new: (self node numArgs + self node temporaries size) ]
]

{ #category : #accessing }
SWDecoder >> slot: anObject [

	slot := anObject
]
