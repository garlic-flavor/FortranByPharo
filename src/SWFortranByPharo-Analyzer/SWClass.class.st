"
SWClass represents a class in this analyzing system.

SWClass is an argument of #initializeInstanceSideTranspiler: and #initializeClassSideTranspiler:.
In these methods, some SWClass>>#define*** methods are called to supply informations to help analyzation and transpilation.

A Writer of a transpiler, may make subclass of SWClass, and override #newTranspiler*** methods to suit.
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
	#category : #'SWFortranByPharo-Analyzer-Analyzer'
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

{ #category : #api }
SWClass >> defineMethod: aName as: rType with: aCalleeGenerator [
	self generator at: aName put: [ :aCallee |
		self newTranspilerOf: aCallee as: rType with: aCalleeGenerator
	]

]

{ #category : #api }
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

{ #category : #accessing }
SWClass >> getMethodTranspiler: aCalleeInfo [
	"This returns a decoded transpiler.
	The returned object is derived from SWCalleeInfo. 
	but the returned object never equal to the instance of aCalleeInfo."

	^ self methods detect: [ :one | one = aCalleeInfo ] ifNone: [|transpiler|
		transpiler := self definedMethod: aCalleeInfo ifAbsent: [
			(self transpilerClass newFrom: aCalleeInfo)
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
	"Return SWVariableInfo in slots at 0 based offset."
	^ self slot atOffset: offset.
]

{ #category : #accessing }
SWClass >> getVariableInfoOf: aName [
	"Return SWVariableInfo searched by its name."
	^ self slot detect: [ :each | each isNotNil and: [ each name = aName ] ]

]

{ #category : #accessing }
SWClass >> methods [
	"A Set object consists of referenced methods."
	^ methods ifNil: [methods := Set new ]
]

{ #category : #accessing }
SWClass >> methods: anObject [

	methods := anObject
]

{ #category : #'to extends' }
SWClass >> newTranspilerAsBinaryOperatorOf: aCallee [
	^ (self transpilerClass newFrom: aCallee)
		return: aCallee stack first;
		markAsDecoded;
		yourself

]

{ #category : #'to extends' }
SWClass >> newTranspilerOf: aCallee as: rType [
	^ (self transpilerClass newFrom: aCallee)
		specifyReturnTypeAs: rType;
		markAsDecoded;
		yourself

]

{ #category : #'to extends' }
SWClass >> newTranspilerOf: aCallee as: rType with: aCalleeGenerator [
	^ self newTranspilerOf: aCallee as: rType
]

{ #category : #'to extends' }
SWClass >> newTranspilerOf: aCallee with: aCalleeGenerator [
	^ (self transpilerClass newFrom: aCallee)
		yourself
	
]

{ #category : #'to extends' }
SWClass >> newTranspilerReturnsFirstArgumentOf: aCallee [
	^ (self transpilerClass newFrom: aCallee)
		return: (aCallee stack at: 1);
		markAsDecoded;
		yourself

]

{ #category : #'to extends' }
SWClass >> newTranspilerReturnsFirstArgumentOf: aCallee with: aCalleeGenerator [
	^ self newTranspilerReturnsFirstArgumentOf: aCallee

]

{ #category : #'to extends' }
SWClass >> newTranspilerReturnsFirstOrSecondArgumentOf: aCallee [
	^ (self transpilerClass newFrom: aCallee)
		return: ((SWVariableTypeInfo new)
			<< (aCallee stack at: 1);
			<< (aCallee stack at: 2);
			yourself);
		markAsDecoded;
		yourself

]

{ #category : #'to extends' }
SWClass >> newTranspilerReturnsFirstOrSecondArgumentOf: aCallee with: aCalleeGenerator [
	^ self newTranspilerReturnsFirstOrSecondArgumentOf: aCallee

]

{ #category : #'to extends' }
SWClass >> newTranspilerReturnsReceiverOf: aCallee [
	^ (self transpilerClass newFrom: aCallee)
		return: aCallee stack first;
		markAsDecoded;
		yourself

]

{ #category : #'to extends' }
SWClass >> newTranspilerReturnsReceiverOf: aCallee with: aCalleeGenerator [
	^ self newTranspilerReturnsReceiverOf: aCallee

]

{ #category : #'to extends' }
SWClass >> newTranspilerReturnsReceiversClassOf: aCallee [
	^ (self transpilerClass newFrom: aCallee)
		return: (SWVariableTypeInfo new: aCallee receiverClass classSide);
		markAsDecoded;
		yourself

]

{ #category : #'to extends' }
SWClass >> newTranspilerReturnsReceiversInstanceOf: aCallee [
	^ (self transpilerClass newFrom: aCallee)
		return: (SWVariableTypeInfo new: aCallee receiverClass instanceSide);
		markAsDecoded;
		yourself.

]

{ #category : #'to extends' }
SWClass >> newTranspilerReturnsSecondArgumentOf: aCallee [
	^ (self transpilerClass newFrom: aCallee)
		return: (aCallee stack at: 2);
		markAsDecoded;
		yourself

]

{ #category : #accessing }
SWClass >> pool [
	"A SWPool object"
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
		self halt
	]

]

{ #category : #accessing }
SWClass >> slot [
	"A slot consists of member variables.
	In Pharo object, a member variable has its own 'offset' represented by its #stackPos."

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
