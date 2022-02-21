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
SWDecoder >> atClosure: aBlockNode [
	self result << ((SWContainerType new: BlockClosure)
		elementType: self children last result;
		yourself)

]

{ #category : #accessing }
SWDecoder >> atInteger: anInteger [
	self result << anInteger class

]

{ #category : #accessing }
SWDecoder >> atMessage: aMessageNode [
	self result << (self pool getResult: aMessageNode selector with: (self children collect: [ :each | each result ])).
		
]

{ #category : #accessing }
SWDecoder >> atMethod: traverser [
	self methodResult << (SWVariableType new: self slot first value with: SWType receiverTypePriority)
]

{ #category : #accessing }
SWDecoder >> atPragma: aPragmaNode [
	(self haltList includes: #pragma) ifTrue: [ self halt ]
]

{ #category : #accessing }
SWDecoder >> atReturn: aReturnNode [
	self methodResult << (self resultIsLastChildsResult)

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
SWDecoder >> atVariable: aVariableNode [
	self result << (self slot detect: [ :each | each name = aVariableNode name ] ifNone: [
		self logger log: [ 'Access to global: ', aVariableNode name ].
		(Smalltalk globals at: aVariableNode name) class
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
	methodResult ifNil: [ methodResult := SWVariableType new ].
	self children: (OrderedCollection new: self node children size).
	self node children do: [ :child |
		self children addLast: (self decodeChildWith: child)
	].
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

{ #category : #initialization }
SWDecoder >> enableLogging [
	self logger enabled: true
]

{ #category : #accessing }
SWDecoder >> haltAt: aSymbol [
	self haltList add: aSymbol
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

{ #category : #'as yet unclassified' }
SWDecoder >> resultIsLastChildsResult [
	self children ifNotEmpty: [
		self result << self children last result
	].
	^ self result

]

{ #category : #accessing }
SWDecoder >> slot [

	^ slot ifNil: [ slot := OrderedCollection new: (self node numArgs + self node temporaries size) ]
]

{ #category : #accessing }
SWDecoder >> slot: anObject [

	slot := anObject
]
