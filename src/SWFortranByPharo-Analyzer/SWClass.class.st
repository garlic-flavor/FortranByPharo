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
		'slot',
		'methods',
		'predefined'
	],
	#category : #'SWFortranByPharo-Analyzer-Analyzer'
}

{ #category : #adding }
SWClass >> addDecoderInitializer: aName with: anInitializer [
	self error; flag: #toRemove.
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
SWClass >> addPredefined: aName with: initializer [
	self predefined at: aName put: initializer.

]

{ #category : #adding }
SWClass >> addSenderInitializer: aName with: initializer [
	self error; flag: #toRemove.
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

{ #category : #api }
SWClass >> declareMethod: aName as: initializer [
	self error; flag: #toRemove.
	self addSenderInitializer: aName with: initializer

]

{ #category : #api }
SWClass >> declareMethod: aName asReturn: rType [
	self addPredefined: aName with: [ :operands |
		rType
	]

]

{ #category : #api }
SWClass >> declareMethodAsBinaryOperator: aName [

	self addPredefined: aName with: [ :operands |
		operands first
	]

]

{ #category : #api }
SWClass >> declareMethodAsCompareOperator: aName [
	self addPredefined: aName with: [ :operands |
		Boolean
	]

]

{ #category : #api }
SWClass >> declareMethodReturnsFirstArgument: aName [
	self addPredefined: aName with: [ :operator |
		operator second
	]

]

{ #category : #api }
SWClass >> declareMethodReturnsFirstArgumentsElement: aName [
	self addPredefined: aName with: [ :operands |
		operands second elementType
	]

]

{ #category : #api }
SWClass >> declareMethodReturnsFirstOrSecondArgument: aName [
	self addPredefined: aName with: [ :operands |
		SWVariableType new
			<< operands second;
			<< operands third;
			yourself
	]

]

{ #category : #api }
SWClass >> declareMethodReturnsFirstOrSecondArgumentsElement: aName [
	self addPredefined: aName with: [ :operands |
		SWVariableType new
			<< operands second elementType;
			<< operands third elementType;
			yourself
	]

]

{ #category : #api }
SWClass >> declareMethodReturnsReceiver: aName [
	self addPredefined: aName with: [ :operands |
		operands first
	]

]

{ #category : #api }
SWClass >> declareMethodReturnsReceiverOrFirstArgument: aName [
	self addPredefined: aName with: [ :operands |
		SWVariableType new
			<< operands first;
			<< operands second;
			yourself
	]

]

{ #category : #api }
SWClass >> declareMethodReturnsReceiverOrFirstArgumentsElement: aName [
	self addPredefined: aName with: [ :operands |
		SWVariableType new
			<< operands first;
			<< operands second elementType;
			yourself
	]

]

{ #category : #api }
SWClass >> declareMethodReturnsReceiversClass: aName [
	self error; flag: #toRemove.
	self addSenderInitializer: aName with: [ :aSender |
		aSender
			specifyReturnTypeAs: aSender operands receiver value classSide;
			yourself
	]

]

{ #category : #api }
SWClass >> declareMethodReturnsReceiversElement: aName [
	self addPredefined: aName with: [ :operands |
		operands first elementType
	]

]

{ #category : #api }
SWClass >> declareMethodReturnsReceiversInstance: aName [
	self addPredefined: aName with: [:operands |
		operands first value instanceSide
	]

]

{ #category : #api }
SWClass >> declareMethodReturnsSecondArgument: aName [
	self addPredefined: aName with: [ :operands |
		operands third
	]

]

{ #category : #api }
SWClass >> declareMethodReturnsSecondArgumentsElement: aName [
	self error; flag: #toRemove.
	self addSenderInitializer: aName with: [ :aSender |
		aSender
			return: aSender operands third type elementType;
			yourself
	]

]

{ #category : #multipart }
SWClass >> decoderClass [
	^ self pool decoderClass
]

{ #category : #accessing }
SWClass >> decoderInitializer [
	self error; flag: #toRemove.
"
	^ decoderInitializer ifNil: [ decoderInitializer := Dictionary new ]
"
]

{ #category : #accessing }
SWClass >> decoderInitializer: anObject [
	self error; flag: #toRemove.
"
	decoderInitializer := anObject
"
]

{ #category : #api }
SWClass >> defineMethodBody: selector as: generator [
	self error; flag: #toRemove.

]

{ #category : #api }
SWClass >> defineMethodSender: aSelector as: anInitializer [
	self error; flag: #toRemove.

]

{ #category : #'as yet unclassified' }
SWClass >> getResult: method with: operands [
	|sender|
	sender := SWSender new
		method: method;
		operands: operands;
		yourself.
	^ self methods at: sender ifAbsent: [
		self predefined at: method selector ifPresent: [ :pre |
			self methods at: sender put: (pre cull: operands)
		] ifAbsent: [ |result|
			result := SWVariableType new.
			self methods at: sender put: result.
			self decoderClass new
				logger: self logger;
				haltList: self haltList;
				pool: self pool;
				node: method sourceNode;
				slot: self slot copy;
				operands: operands;
				methodResult: result;
				decode
		]
	]

]

{ #category : #api }
SWClass >> getSenderOf: aMethod receiver: receiver with: args [
	|sender code|
self error; flag: #toRemove.
	sender := self senderTranspilerClass new
		selector: aMethod selector;
		method: aMethod;
		receiver: receiver;
		arguments: args;
		yourself.
	self methods associationAt: sender ifPresent: [ :assoc | ^ assoc key copy ].

	code := SWCompiledMethodOld new: aMethod receiver: receiver with: args.
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
self error; flag: #toRemove.
	^ self slot atOffset: offset.
]

{ #category : #api }
SWClass >> getVariableInfoOf: aName [
	"Return SWVariableInfo searched by its name."
self error; flag: #toRemove.
	^ self slot detect: [ :each | each isNotNil and: [ each name = aName ] ]

]

{ #category : #api }
SWClass >> getVariableInfoOf: aName ifPresent: aPresentBlock [
	"Return SWVariableInfo searched by its name."
self error; flag: #toRemove.
	^ self slot detect: [ :each | each isNotNil and: [ each name = aName ] ] ifFound: aPresentBlock

]

{ #category : #'private - accessing' }
SWClass >> haltList [
	^ self pool haltList
]

{ #category : #testing }
SWClass >> hasVariable: aName [
self error; flag: #toRemove.
	^ self slot detect: [ :each | each isNotNil and: [ each name = aName ] ]  ifFound: [ :dummy | true ] ifNone: [ false ]
]

{ #category : #accessing }
SWClass >> logger [
	^ self pool logger
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
self halt; flag: #toRewrite.
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

{ #category : #accessing }
SWClass >> predefined [

	^ predefined ifNil: [ predefined := Dictionary new ]
]

{ #category : #accessing }
SWClass >> predefined: anObject [

	predefined := anObject
]

{ #category : #streaming }
SWClass >> putOn: aStream [
	aStream << self targetClass name
]

{ #category : #accessing }
SWClass >> senderInitializer [
	self error; flag: #toRemove.
"
	^ senderInitializer ifNil: [ senderInitializer := Dictionary new ]
"
]

{ #category : #accessing }
SWClass >> senderInitializer: anObject [
	self error; flag: #toRemove.
"
	senderInitializer := anObject
"
]

{ #category : #accessing }
SWClass >> senderTranspilerClass [
"
	^ self pool senderTranspilerClass 
"
]

{ #category : #api }
SWClass >> setBreakpointOn: aName [
	self addPredefined: aName with: [ :operands |
		self halt.
	]

]

{ #category : #accessing }
SWClass >> slot [
	^ slot ifNil: [
		slot := SWSlot new.
		self targetClass slots do: [ :ids |
			slot push name: ids name
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
	self error; flag: #toRemove.

	^ self pool transpilerClass
]
