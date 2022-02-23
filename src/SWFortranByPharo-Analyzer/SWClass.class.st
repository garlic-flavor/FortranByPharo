"
SWClass represents a class in this analyzing system.

SWClass is an argument of #initializeInstanceSideTranspiler: and #initializeClassSideTranspiler:.
In these methods, some SWClass>>#define*** methods are called to supply informations to help analyzation and transpilation.

A Writer of a transpiler, may make subclass of SWClass, and override #newTranspiler*** methods to suit.
"
Class {
	#name : #SWClass,
	#superclass : #SWClassBase,
	#instVars : [
		'slot',
		'methods',
		'predefined'
	],
	#category : #'SWFortranByPharo-Analyzer-Analyzer'
}

{ #category : #adding }
SWClass >> addPredefined: aName with: initializer [
	self predefined at: aName put: initializer.

]

{ #category : #adding }
SWClass >> addSlotAbout: aClass [
	aClass ifNil: [ ^ self ].
	aClass slots do: [ :item |
		slot push name: item name
	].
	aClass classVarNames do: [ :item |
		slot push name: item
	].
	self addSlotAbout: aClass superclass
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
		SWVariable new
			<< operands second;
			<< operands third;
			yourself
	]

]

{ #category : #api }
SWClass >> declareMethodReturnsFirstOrSecondArgumentsElement: aName [
	self addPredefined: aName with: [ :operands |
		SWVariable new
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
		SWVariable new
			<< operands first;
			<< operands second;
			yourself
	]

]

{ #category : #api }
SWClass >> declareMethodReturnsReceiverOrFirstArgumentsElement: aName [
	self addPredefined: aName with: [ :operands |
		SWVariable new
			<< operands first;
			<< operands second elementType;
			yourself
	]

]

{ #category : #api }
SWClass >> declareMethodReturnsReceiversClass: aName [
	self addPredefined: aName with: [ :operands |
		operands first value classSide
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

{ #category : #accessing }
SWClass >> decoderClass [
	^ self pool decoderClass
]

{ #category : #api }
SWClass >> getResult: aSender [
	(self haltList includes: aSender method) ifTrue: [ self halt ].
	^ self methods at: aSender ifPresent: [ :found |
		found sender
	] ifAbsent: [
		self predefined at: aSender method selector ifPresent: [ :pre |
			aSender result << (pre cull: aSender operands).
			self methods at: aSender put: aSender.
		] ifAbsent: [ |decoder|
			decoder := self newMethodDecoder: aSender.
			self methods at: aSender put: decoder.
			decoder
				decode;
				sender
		]
	]

]

{ #category : #accessing }
SWClass >> haltList [
	^ self pool haltList
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

{ #category : #'instance creation' }
SWClass >> newMethodDecoder: aSender [
	^ self decoderClass new
		logger: self logger;
		haltList: self haltList;
		pool: self pool;
		slot: self slot copy;
		method: aSender method;
		operands: aSender operands;
		yourself
]

{ #category : #accessing }
SWClass >> predefined [

	^ predefined ifNil: [ predefined := Dictionary new ]
]

{ #category : #accessing }
SWClass >> predefined: anObject [

	predefined := anObject
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
		self addSlotAbout: self targetClass.
		slot
	]
]

{ #category : #accessing }
SWClass >> slot: anObject [

	slot := anObject
]
