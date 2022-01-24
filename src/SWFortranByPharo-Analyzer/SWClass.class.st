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
SWClass >> defineMethod: aName as: initializer [
	self generator at: aName put: [ :aCallee |
		initializer value: (self transpilerClass newFrom: aCallee)
	]

]

{ #category : #api }
SWClass >> defineMethod: aName asReturn: rType [
	^ self defineMethod: aName as: [ :newT |
		newT
			specifyReturnTypeAs: rType;
			markAsDecoded;
			yourself
	]

]

{ #category : #api }
SWClass >> defineMethodAsBinaryOperator: aName [
	^ self defineMethodAsBinaryOperator: aName as: [ :newT | newT ]

]

{ #category : #api }
SWClass >> defineMethodAsBinaryOperator: aName as: anInitializer [
	self generator at: aName put: [ :aCallee |
		anInitializer value: ((self transpilerClass newFrom: aCallee)
			return: aCallee stack first;
			markAsDecoded;
			yourself)
	]

]

{ #category : #api }
SWClass >> defineMethodAsCompareOperator: aName [
	^ self defineMethodAsBinaryOperator: aName

]

{ #category : #api }
SWClass >> defineMethodReturnsFirstArgument: aName [
	^ self defineMethodReturnsFirstArgument: aName as: [ :newT | newT ]

]

{ #category : #api }
SWClass >> defineMethodReturnsFirstArgument: aName as: anInitializer [
	self generator at: aName put: [ :aCallee |
		anInitializer value: ((self transpilerClass newFrom: aCallee)
			return: (aCallee stack at: 1);
			markAsDecoded;
			yourself)
	]

]

{ #category : #api }
SWClass >> defineMethodReturnsFirstOrSecondArgument: aName [
	^ self defineMethodReturnsFirstOrSecondArgument: aName as: [ :newT | newT ]

]

{ #category : #api }
SWClass >> defineMethodReturnsFirstOrSecondArgument: aName as: anInitializer [
	self generator at: aName put: [ :aCallee |
		anInitializer value: ((self transpilerClass newFrom: aCallee)
		return: ((SWVariableTypeInfo new)
			<< (aCallee stack at: 1);
			<< (aCallee stack at: 2);
			yourself);
		markAsDecoded;
		yourself)
	]

]

{ #category : #api }
SWClass >> defineMethodReturnsReceiver: aName [
	^ self defineMethodReturnsReceiver: aName as: [ :newT | newT ]

]

{ #category : #api }
SWClass >> defineMethodReturnsReceiver: aName as: anInitializer [
	self generator at: aName put: [ :aCallee |
		anInitializer value: ((self transpilerClass newFrom: aCallee)
		return: aCallee stack first;
		markAsDecoded;
		yourself)
	]

]

{ #category : #api }
SWClass >> defineMethodReturnsReceiversClass: aName [
	self generator at: aName put: [:aCallee |
		(self transpilerClass newFrom: aCallee)
			return: (SWVariableTypeInfo new: aCallee receiverClass classSide);
			markAsDecoded;
			yourself
	]

]

{ #category : #api }
SWClass >> defineMethodReturnsReceiversInstance: aName [
	self generator at: aName put: [:aCallee |
		(self transpilerClass newFrom: aCallee)
			return: (SWVariableTypeInfo new: aCallee receiverClass instanceSide);
			markAsDecoded;
			yourself
	]

]

{ #category : #api }
SWClass >> defineMethodReturnsSecondArgument: aName [
	self generator at: aName put: [ :aCallee |
		(self transpilerClass newFrom: aCallee)
			return: (aCallee stack at: 2);
			markAsDecoded;
			yourself
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
SWClass >> getVariableInfoOf: aName ifPresent: aPresentBlock [
	"Return SWVariableInfo searched by its name."
	^ self slot detect: [ :each | each isNotNil and: [ each name = aName ] ] ifFound: aPresentBlock

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
