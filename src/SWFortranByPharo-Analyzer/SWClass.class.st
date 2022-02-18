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
		'pool',
		'classSide',
		'slot',
		'methods',
		'senderInitializer',
		'decoderInitializer'
	],
	#category : #'SWFortranByPharo-Analyzer-Analyzer'
}

{ #category : #adding }
SWClass >> addDecoderInitializer: aName with: anInitializer [
	self decoderInitializer at: aName ifPresent: [ :ini |
		self decoderInitializer at: aName put: [ :decoder |
			ini cull: decoder.
			anInitializer cull: decoder.
			decoder
		]
	] ifAbsentPut: [
		anInitializer
	]
]

{ #category : #adding }
SWClass >> addSenderInitializer: aName with: initializer [
	self senderInitializer at: aName ifPresent: [ :ini |
		self senderInitializer at: aName put: [ :aSender |
			ini cull: aSender.
			initializer cull: aSender.
			aSender
		]
	] ifAbsentPut: [
		initializer
	]
]

{ #category : #accessing }
SWClass >> classSide [

	^ classSide
]

{ #category : #accessing }
SWClass >> classSide: anObject [

	classSide := anObject
]

{ #category : #api }
SWClass >> declareMethod: aName as: initializer [
	self addSenderInitializer: aName with: initializer

]

{ #category : #api }
SWClass >> declareMethod: aName asReturn: rType [
	self addSenderInitializer: aName with: [ :aSender |
		aSender
			specifyReturnTypeAs: rType;
			yourself
	]

]

{ #category : #api }
SWClass >> declareMethodAsBinaryOperator: aName [

	self addSenderInitializer: aName with: [ :aSender |
		aSender
			return: aSender operands receiver;
			yourself
	]

]

{ #category : #api }
SWClass >> declareMethodAsCompareOperator: aName [
	self addSenderInitializer: aName with: [ :aSender |
		aSender
			specifyReturnTypeAs: Boolean;
			yourself
	]

]

{ #category : #api }
SWClass >> declareMethodReturnsFirstArgument: aName [
	self addSenderInitializer: aName with: [ :aSender |
		aSender
			specifyReturnTypeAs: aSender operands second;
			yourself
	]

]

{ #category : #api }
SWClass >> declareMethodReturnsFirstArgumentsElement: aName [
	self addSenderInitializer: aName with: [ :aSender |
		aSender
			return: aSender operands second type elementType;
			yourself
	]

]

{ #category : #api }
SWClass >> declareMethodReturnsFirstOrSecondArgument: aName [
	self addSenderInitializer: aName with: [ :aSender |
		aSender
			return: ((SWVariableTypeInfo new)
				<< aSender operands second;
				<< aSender operands third;
				yourself);
			yourself
	]

]

{ #category : #api }
SWClass >> declareMethodReturnsReceiver: aName [
	self addSenderInitializer: aName with: [ :aSender |
		aSender
			return: aSender operands receiver;
			yourself
	]

]

{ #category : #api }
SWClass >> declareMethodReturnsReceiversClass: aName [
	self addSenderInitializer: aName with: [ :aSender |
		aSender
			specifyReturnTypeAs: aSender operands receiver value classSide;
			yourself
	]

]

{ #category : #api }
SWClass >> declareMethodReturnsReceiversElement: aName [
	self addSenderInitializer: aName with: [ :aSender |
		aSender
			return: aSender operands receiver type elementType;
			yourself
	]

]

{ #category : #api }
SWClass >> declareMethodReturnsReceiversInstance: aName [
	self addSenderInitializer: aName with: [:aSender |
		aSender
			specifyReturnTypeAs: aSender operands receiver value instanceSide;
			yourself
	]

]

{ #category : #api }
SWClass >> declareMethodReturnsSecondArgument: aName [
	self addSenderInitializer: aName with: [ :aSender |
		aSender
			return: aSender operands third;
			yourself
	]

]

{ #category : #api }
SWClass >> declareMethodReturnsSecondArgumentsElement: aName [
	self addSenderInitializer: aName with: [ :aSender |
		aSender
			return: aSender operands third type elementType;
			yourself
	]

]

{ #category : #accessing }
SWClass >> decoderInitializer [

	^ decoderInitializer ifNil: [ decoderInitializer := Dictionary new ]
]

{ #category : #accessing }
SWClass >> decoderInitializer: anObject [

	decoderInitializer := anObject
]

{ #category : #api }
SWClass >> defineMethodBody: selector as: generator [
]

{ #category : #api }
SWClass >> defineMethodSender: aSelector as: anInitializer [
]

{ #category : #api }
SWClass >> getSenderOf: aMethod receiver: receiver with: args [
	|sender code|

	sender := self senderTranspilerClass new
		selector: aMethod selector;
		method: aMethod;
		receiver: receiver;
		arguments: args;
		yourself.
	self methods associationAt: sender ifPresent: [ :assoc | ^ assoc key copy ].

	code := SWCompiledMethod new: aMethod receiver: receiver with: args.
	^ self senderInitializer at: sender selector ifPresent: [ :gen ||newS|
		newS := gen value: sender.
		self methods at: newS put: code.
		newS return ifNil: [
			(self newDecoderOf: code) decode.
			newS return: code return.
		].
		newS copy
	] ifAbsent: [
		self methods at: sender put: code.
		(self newDecoderOf: code) decode.
		sender return: code return.
		sender copy
	]

]

{ #category : #api }
SWClass >> getVariableInfoAtOffset: offset [
	"Return SWVariableInfo in slots at 0 based offset."
	^ self slot atOffset: offset.
]

{ #category : #api }
SWClass >> getVariableInfoOf: aName [
	"Return SWVariableInfo searched by its name."
	^ self slot detect: [ :each | each isNotNil and: [ each name = aName ] ]

]

{ #category : #api }
SWClass >> getVariableInfoOf: aName ifPresent: aPresentBlock [
	"Return SWVariableInfo searched by its name."
	^ self slot detect: [ :each | each isNotNil and: [ each name = aName ] ] ifFound: aPresentBlock

]

{ #category : #testing }
SWClass >> hasVariable: aName [
self error; flag: #toRemove.
	^ self slot detect: [ :each | each isNotNil and: [ each name = aName ] ]  ifFound: [ :dummy | true ] ifNone: [ false ]
]

{ #category : #accessing }
SWClass >> methods [
	"A Set object consists of referenced methods."
	^ methods ifNil: [methods := Dictionary new ]
]

{ #category : #accessing }
SWClass >> methods: anObject [

	methods := anObject
]

{ #category : #private }
SWClass >> newDecoderOf: aCompiledCode [
	|decoder|
	decoder := (self transpilerClass new: aCompiledCode)
		classInfo: self;
		pool: self pool;
		logger: self pool logger;
		haltList: self pool owner haltList;
		yourself.
	self decoderInitializer at: aCompiledCode selector ifPresent: [ :ini |
		decoder := ini cull: decoder
	].
	^ decoder
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

{ #category : #accessing }
SWClass >> senderInitializer [

	^ senderInitializer ifNil: [ senderInitializer := Dictionary new ]
]

{ #category : #accessing }
SWClass >> senderInitializer: anObject [

	senderInitializer := anObject
]

{ #category : #accessing }
SWClass >> senderTranspilerClass [
	^ self pool senderTranspilerClass 
]

{ #category : #api }
SWClass >> setBreakpointOn: aName [
	self senderInitializer at: aName put: [ :aCallee |
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
			(slot at: ids index) name: ids name
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
	targetClass := anObject.

]

{ #category : #accessing }
SWClass >> transpilerClass [

	^ self pool transpilerClass
]
