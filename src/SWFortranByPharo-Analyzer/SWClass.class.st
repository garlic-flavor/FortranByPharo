"
I hold type information about a class to transpile.

"
Class {
	#name : #SWClass,
	#superclass : #Object,
	#instVars : [
		'targetClass',
		'methods',
		'generator',
		'pool',
		'sourceHash',
		'slot',
		'classSide'
	],
	#category : #'SWFortranByPharo-Analyzer-Class'
}

{ #category : #accessing }
SWClass >> classSide [

	^ classSide ifNil: [ classSide := self class new ]
]

{ #category : #accessing }
SWClass >> classSide: anObject [

	classSide := anObject
]

{ #category : #api }
SWClass >> defineMethod: aName as: rType [
	self generator at: aName put: [ :aCallee |
		self newTranspilerOf: aCallee as: rType
	]

]

{ #category : #'as yet unclassified' }
SWClass >> defineMethod: aName as: rType with: aCalleeGenerator [
	self generator at: aName put: [ :aCallee |
		self newTranspilerOf: aCallee as: rType with: aCalleeGenerator
	]

]

{ #category : #'as yet unclassified' }
SWClass >> defineMethod: aName with: aCalleeGenerator [
	self generator at: aName put: [ :aCallee |
		self newTranspilerOf: aCallee with: aCalleeGenerator
	]

]

{ #category : #api }
SWClass >> defineMethodAsBinaryOperator: aName [
	self generator at: aName put: [ :aCallee |
		self newTranspilerAsBinaryOperatorOf: aCallee
	]

]

{ #category : #api }
SWClass >> defineMethodAsCompareOperator: aName [
	self generator at: aName put: [ :aCallee |
		self newTranspilerAsBinaryOperatorOf: aCallee
	]

]

{ #category : #api }
SWClass >> defineMethodReturnsFirstArgument: aName [
	self generator at: aName put: [ :aCallee |
		self newTranspilerReturnsFirstArgumentOf: aCallee
	]

]

{ #category : #api }
SWClass >> defineMethodReturnsFirstArgument: aName with: aCalleeGenerator [
	self generator at: aName put: [ :aCallee |
		self newTranspilerReturnsFirstArgumentOf: aCallee with: aCalleeGenerator
	]

]

{ #category : #api }
SWClass >> defineMethodReturnsFirstOrSecondArgument: aName [
	self generator at: aName put: [ :aCallee |
		self newTranspilerReturnsFirstOrSecondArgumentOf: aCallee
	]

]

{ #category : #api }
SWClass >> defineMethodReturnsFirstOrSecondArgument: aName with: aCalleeGenerator [
	self generator at: aName put: [ :aCallee |
		self newTranspilerReturnsFirstOrSecondArgumentOf: aCallee with: aCalleeGenerator
	]

]

{ #category : #api }
SWClass >> defineMethodReturnsReceiver: aName [
	self generator at: aName put: [ :aCallee |
		self newTranspilerReturnsReceiverOf: aCallee
	]

]

{ #category : #api }
SWClass >> defineMethodReturnsReceiver: aName with: aCalleeGenerator [
	self generator at: aName put: [ :aCallee |
		self newTranspilerReturnsReceiverOf: aCallee with: aCalleeGenerator
	]

]

{ #category : #api }
SWClass >> defineMethodReturnsReceiversClass: aName [
	self generator at: aName put: [:aCallee |
		self newTranspilerReturnsReceiversClassOf: aCallee
	]

]

{ #category : #api }
SWClass >> defineMethodReturnsReceiversInstance: aName [
	self generator at: aName put: [:aCallee |
		self newTranspilerReturnsReceiversInstanceOf: aCallee
	]

]

{ #category : #api }
SWClass >> defineMethodReturnsSecondArgument: aName [
	self generator at: aName put: [ :aCallee |
		self newTranspilerReturnsSecondArgumentOf: aCallee
	]

]

{ #category : #api }
SWClass >> defineTypeOf: aName is: aType [

	(self getVariableInfoOf: aName) << aType

]

{ #category : #private }
SWClass >> definedMethod: aCallee ifAbsent: absentBlock [

	^ self generator at: aCallee selector ifPresent: [ :gen |
		gen value: aCallee
	] ifAbsent: [
		absentBlock value
	].

]

{ #category : #accessing }
SWClass >> generator [

	^ generator ifNil: [ generator := Dictionary new ]
]

{ #category : #accessing }
SWClass >> generator: anObject [

	generator := anObject
]

{ #category : #'instance creation' }
SWClass >> getMethodTranspiler: aCallee [

	^ self methods detect: [ :one | one = aCallee ] ifNone: [|transpiler|
		transpiler := self definedMethod: aCallee ifAbsent: [
			(self transpilerClass newFrom: aCallee)
				classInfo: self;
				pool: self pool;
				yourself.
		].
		self methods add: transpiler.
		transpiler
			decode;
			yourself
	].

]

{ #category : #accessing }
SWClass >> getVariableInfoAtOffset: offset [
	"Return SWVariableInfo in slots at offset."
	^ self slot atOffset: offset.
]

{ #category : #accessing }
SWClass >> getVariableInfoOf: aName [
	"Return SWVariableInfo searched by its name."
	^ self slot detect: [ :each | each isNotNil and: [ each name = aName ] ]

]

{ #category : #accessing }
SWClass >> methods [

	^ methods ifNil: [methods := Set new ]
]

{ #category : #accessing }
SWClass >> methods: anObject [

	methods := anObject
]

{ #category : #'instance creation' }
SWClass >> newTranspilerAsBinaryOperatorOf: aCallee [
	^ (self transpilerClass newFrom: aCallee)
		return: aCallee stack first;
		markAsDecoded;
		yourself

]

{ #category : #'instance creation' }
SWClass >> newTranspilerOf: aCallee as: rType [
	^ (self transpilerClass newFrom: aCallee)
		specifyReturnTypeAs: (rType isBlock ifTrue: [ self error; flag: #toRemove. rType value: aCallee ] ifFalse: [ rType ]);
		markAsDecoded;
		yourself

]

{ #category : #'instance creation' }
SWClass >> newTranspilerOf: aCallee as: rType with: aCalleeGenerator [
	^ self newTranspilerOf: aCallee as: rType
]

{ #category : #'instance creation' }
SWClass >> newTranspilerOf: aCallee with: aCalleeGenerator [
	^ (self transpilerClass newFrom: aCallee)
		yourself
	
]

{ #category : #'instance creation' }
SWClass >> newTranspilerReturnsFirstArgumentOf: aCallee [
	^ (self transpilerClass newFrom: aCallee)
		return: (aCallee stack at: 1);
		markAsDecoded;
		yourself

]

{ #category : #'instance creation' }
SWClass >> newTranspilerReturnsFirstArgumentOf: aCallee with: aCalleeGenerator [
	^ self newTranspilerReturnsFirstArgumentOf: aCallee

]

{ #category : #'instance creation' }
SWClass >> newTranspilerReturnsFirstOrSecondArgumentOf: aCallee [
	^ (self transpilerClass newFrom: aCallee)
		return: ((SWVariableTypeInfo new)
			<< (aCallee stack at: 1);
			<< (aCallee stack at: 2);
			yourself);
		markAsDecoded;
		yourself

]

{ #category : #'instance creation' }
SWClass >> newTranspilerReturnsFirstOrSecondArgumentOf: aCallee with: aCalleeGenerator [
	^ self newTranspilerReturnsFirstOrSecondArgumentOf: aCallee

]

{ #category : #'instance creation' }
SWClass >> newTranspilerReturnsReceiverOf: aCallee [
	^ (self transpilerClass newFrom: aCallee)
		return: aCallee stack first;
		markAsDecoded;
		yourself

]

{ #category : #'instance creation' }
SWClass >> newTranspilerReturnsReceiverOf: aCallee with: aCalleeGenerator [
	^ self newTranspilerReturnsReceiverOf: aCallee

]

{ #category : #'instance creation' }
SWClass >> newTranspilerReturnsReceiversClassOf: aCallee [
	^ (self transpilerClass newFrom: aCallee)
		return: (SWVariableTypeInfo new: aCallee receiverClass classSide);
		markAsDecoded;
		yourself

]

{ #category : #'instance creation' }
SWClass >> newTranspilerReturnsReceiversInstanceOf: aCallee [
	^ (self transpilerClass newFrom: aCallee)
		return: (SWVariableTypeInfo new: aCallee receiverClass instanceSide);
		markAsDecoded;
		yourself.

]

{ #category : #'instance creation' }
SWClass >> newTranspilerReturnsSecondArgumentOf: aCallee [
	^ (self transpilerClass newFrom: aCallee)
		return: (aCallee stack at: 2);
		markAsDecoded;
		yourself

]

{ #category : #accessing }
SWClass >> pool [

	^ pool
]

{ #category : #accessing }
SWClass >> pool: anObject [

	pool := anObject
]

{ #category : #streaming }
SWClass >> putOn: aStream [
	aStream << self targetClass name
]

{ #category : #api }
SWClass >> setBreakpointOn: aName [
	self generator at: aName put: [ :aCallee |
		self error
	]

]

{ #category : #accessing }
SWClass >> slot [
	^ slot ifNil: [
		slot := SWSlot new.
		self targetClass slots do: [ :ids |
			(slot at: ids index)
				name: ids name;
				owner: self;
				stackPos: ids index
		].
		slot
	]
]

{ #category : #accessing }
SWClass >> slot: anObject [

	slot := anObject
]

{ #category : #accessing }
SWClass >> targetClass [

	^ targetClass
]

{ #category : #accessing }
SWClass >> targetClass: anObject [

	|initializer|
	targetClass := anObject.
	initializer := targetClass isInstanceSide
		ifTrue: [ #initializeInstanceSideTranspiler: ] ifFalse: [ #initializeClassSideTranspiler: ].
	(targetClass instanceSide respondsTo: initializer) ifTrue: [
		targetClass instanceSide perform: initializer with: self
	]

]

{ #category : #accessing }
SWClass >> transpilerClass [

	^ self pool transpilerClass
]
