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

	^ classSide ifNil: [
		classSide := self class new
			pool: self pool;
			targetClass: self targetClass classSide;
			yourself
	]
]

{ #category : #accessing }
SWClass >> classSide: anObject [

	classSide := anObject
]

{ #category : #api }
SWClass >> defineMethod: aName as: initializer [
self error; flag: #toRemove.

	self generator at: aName put: [ :aCallee |
		initializer value: (self transpilerClass newFrom: aCallee)
	]

]

{ #category : #api }
SWClass >> defineMethod: aName asReturn: rType [
	self generator at: aName put: [ :aSender |
		aSender
			specifyReturnTypeAs: rType;
			yourself
	]

]

{ #category : #api }
SWClass >> defineMethodAsBinaryOperator: aName [

	self generator at: aName put: [ :aSender |
		aSender
			return: aSender operands first;
			yourself
	]

]

{ #category : #api }
SWClass >> defineMethodAsBinaryOperator: aName as: anInitializer [
self error; flag: #toRemove.

	self generator at: aName put: [ :aSender |
		anInitializer value: (aSender
			return: aSender operands first;
			yourself)
	]

]

{ #category : #api }
SWClass >> defineMethodAsCompareOperator: aName [
	self generator at: aName put: [ :aSender |
		aSender
			specifyReturnTypeAs: Boolean;
			yourself
	]

]

{ #category : #api }
SWClass >> defineMethodAsCompareOperator: aName as: anInitializer [
self error; flag: #toRemove.

	self generator at: aName put: [ :aCallee |
		anInitializer value: ((self transpilerClass newFrom: aCallee)
			specifyReturnTypeAs: Boolean;
			markAsDecoded;
			yourself)
	]

]

{ #category : #api }
SWClass >> defineMethodReturnsFirstArgument: aName [
	self generator at: aName put: [ :aSender |
		aSender
			return: aSender operands second;
			yourself
	]

]

{ #category : #api }
SWClass >> defineMethodReturnsFirstArgument: aName as: anInitializer [
self error; flag: #toRemove.
	self generator at: aName put: [ :aCallee |
		anInitializer value: ((self transpilerClass newFrom: aCallee)
			return: (aCallee stack at: 1);
			markAsDecoded;
			yourself)
	]

]

{ #category : #api }
SWClass >> defineMethodReturnsFirstOrSecondArgument: aName [
	self generator at: aName put: [ :aSender |
		aSender
			return: ((SWVariableTypeInfo new)
				<< aSender operands second;
				<< aSender operands third;
				yourself);
			yourself
	]

]

{ #category : #api }
SWClass >> defineMethodReturnsFirstOrSecondArgument: aName as: anInitializer [
self error; flag: #toRemove.
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
	self generator at: aName put: [ :aSender |
		aSender
			return: aSender operands first;
			yourself
	]

]

{ #category : #api }
SWClass >> defineMethodReturnsReceiver: aName as: anInitializer [
self error; flag: #toRemove.
	self generator at: aName put: [ :aCallee |
		anInitializer value: ((self transpilerClass newFrom: aCallee)
		return: aCallee stack first;
		markAsDecoded;
		yourself)
	]

]

{ #category : #api }
SWClass >> defineMethodReturnsReceiversClass: aName [
	self generator at: aName put: [ :aSender |
		aSender
			specifyReturnTypeAs: aSender operands first value classSide;
			yourself
	]

]

{ #category : #api }
SWClass >> defineMethodReturnsReceiversClass: aName as: anInitializer [
self error; flag: #toRemove.
	self generator at: aName put: [:aCallee |
		anInitializer value: ((self transpilerClass newFrom: aCallee)
			return: (SWVariableTypeInfo new: aCallee receiverClass classSide);
			markAsDecoded;
			yourself)
	]

]

{ #category : #api }
SWClass >> defineMethodReturnsReceiversInstance: aName [
	self generator at: aName put: [:aSender |
		aSender
			specifyReturnTypeAs: aSender operands first value instanceSide;
			yourself
	]

]

{ #category : #api }
SWClass >> defineMethodReturnsSecondArgument: aName [
	self generator at: aName put: [ :aSender |
		aSender
			return: aSender operands third;
			yourself
	]

]

{ #category : #api }
SWClass >> defineTypeOf: aName is: aType [
self error; flag: #toRemove.

	(self getVariableInfoOf: aName) << aType

]

{ #category : #private }
SWClass >> definedMethod: aCallee ifAbsent: absentBlock [
self error; flag: #toRemove.
	^ self generator at: aCallee selector ifPresent: [ :gen |
		gen value: aCallee
	] ifAbsent: [
		absentBlock value
	].

]

{ #category : #private }
SWClass >> definedMethod: aSender ifPresent: presentBlock [
self error; flag: #toRemove.
	self generator at: aSender selector ifPresent: [ :gen |
		presentBlock value: (gen value: aSender)
	]

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
SWClass >> getMethodDecoderOf: aSender [
self error; flag: #toRewrite.

	self methods at: aSender ifAbsent: [ |newT|
		newT := self definedMethod: aSender ifAbsent: [
			(self transpilerClass newFrom: aSender)
				classInfo: self;
				pool: self pool;
				yourself
		]
	]
"	
	detect: [ :one | one = aCalleeInfo ] ifNone: [|transpiler|
		transpiler := self definedMethod: aCalleeInfo ifAbsent: [
			(self transpilerClass newFrom: aCalleeInfo)
				classInfo: self;
				pool: self pool;
				yourself.
		].
		self methods add: transpiler.
		transpiler
			logger: self pool logger;
			decode;
			yourself
	].
"

]

{ #category : #accessing }
SWClass >> getMethodDecoderOf: aSelector with: args [
	self error; flag: #toImplement
"
	^ self methods detect: [ :one | one = aCalleeInfo ] ifNone: [|transpiler|
		transpiler := self definedMethod: aCalleeInfo ifAbsent: [
			(self transpilerClass newFrom: aCalleeInfo)
				classInfo: self;
				pool: self pool;
				yourself.
		].
		self methods add: transpiler.
		transpiler
			logger: self pool logger;
			decode;
			yourself
	].
"

]

{ #category : #accessing }
SWClass >> getMethodTranspiler: aCalleeInfo [
	"This returns a decoded transpiler.
	The returned object is derived from SWCalleeInfo. 
	but the returned object never equal to the instance of aCalleeInfo."
self error; flag: #toRemove.

	^ self methods detect: [ :one | one = aCalleeInfo ] ifNone: [|transpiler|
		transpiler := self definedMethod: aCalleeInfo ifAbsent: [
			(self transpilerClass newFrom: aCalleeInfo)
				classInfo: self;
				pool: self pool;
				yourself.
		].
		self methods add: transpiler.
		transpiler
			logger: self pool logger;
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

{ #category : #initialization }
SWClass >> initialize: aClass [
	|initializer|
	aClass ifNil: [ ^ self ].
	self initialize: aClass superclass.

	initializer := (String streamContents: [ :s |
		s
			<< 'initialize_';
			<< aClass instanceSide name;
			<< (aClass isClassSide ifTrue: [ 'Class' ] ifFalse: [ '' ])
	]) asSymbol.

	(self respondsTo: initializer) ifTrue: [
		self perform: initializer
	]


]

{ #category : #initialization }
SWClass >> initialize_Behavior [
	self
		defineMethodReturnsReceiversInstance: #basicNew:;
		defineMethodReturnsReceiversInstance: #basicNew
]

{ #category : #initialization }
SWClass >> initialize_Boolean [
	self
		defineMethodReturnsFirstOrSecondArgument: #ifTrue:ifFalse:" as: [ :newT |
			newT
				senderGenerator: [ :t :node | t putIfTrueIfFalse: node ];
				yourself
		]";
		defineMethodReturnsFirstArgument: #ifTrue:" as: [ :newT |
			newT
				senderGenerator: [ :t :node | t putIfTrue: node ];
				yourself 
		]";
		defineMethodReturnsFirstArgument: #ifFalse:" as: [ :newT |
			newT
				senderGenerator: [ :t :node | t putIfFalse: node ];
				yourself
		]";
		defineMethodReturnsReceiver: #and:;
		defineMethodReturnsReceiver: #or:

]

{ #category : #initialization }
SWClass >> initialize_CharacterClass [
	self
		defineMethodReturnsReceiversInstance: #cr
]

{ #category : #initialization }
SWClass >> initialize_Dictionary [
	self
		defineMethodReturnsSecondArgument: #at:put:;
		defineMethodReturnsSecondArgument: #at:ifAbsent:
]

{ #category : #initialization }
SWClass >> initialize_Magnitude [
	self
		defineMethodAsCompareOperator: #>=;
		defineMethodAsCompareOperator: #<=;
		defineMethodAsCompareOperator: #>;
		defineMethodAsCompareOperator: #<";
		defineMethodAsCompareOperator: #="

]

{ #category : #initialization }
SWClass >> initialize_Number [
	self
		defineMethodAsBinaryOperator: #+;
		defineMethodAsBinaryOperator: #-;
		defineMethodAsBinaryOperator: #*;
		defineMethodAsBinaryOperator: #/
		
]

{ #category : #initialization }
SWClass >> initialize_Object [
	self
		defineMethodAsCompareOperator: #=;
		defineMethodReturnsReceiver: #error:
]

{ #category : #initialization }
SWClass >> initialize_ProtoObject [
	self
		setBreakpointOn: #primitiveFailed;
		defineMethodAsCompareOperator: #==;
		defineMethodReturnsReceiversClass: #class;
		defineMethodReturnsFirstOrSecondArgument: #ifNil:ifNotNil:
]

{ #category : #initialization }
SWClass >> initialize_Semaphore [
	self
		defineMethodReturnsReceiver: #signal
]

{ #category : #initialization }
SWClass >> initialize_Set [
	self
		defineMethodReturnsFirstOrSecondArgument: #remove:ifAbsent:;
		defineMethodReturnsFirstArgument: #add:
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
SWClass >> newSenderOf: aMethod with: args [
	|sender decoder|

	sender := self senderTranspilerClass new
		selector: aMethod selector;
		operands: args;
		yourself.
	self methods associationAt: sender ifPresent: [ :assoc | ^ assoc key copy ].
	self generator at: sender selector ifPresent: [ :gen ||newS|
		newS := gen value: sender.
		self methods at: newS put: nil.
		^ newS copy
	].
	decoder := (self transpilerClass new: aMethod with: args)
		classInfo: self;
		pool: self pool;
		logger: self pool logger;
		yourself.
	self methods at: sender put: decoder.
	decoder decode.
	sender return: decoder return.
	^ sender copy

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
SWClass >> senderTranspilerClass [
	^ self pool senderTranspilerClass 
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
	targetClass := anObject.
	self initialize: anObject
	"
	self error; flag: #toRemove.
	initializer := targetClass isInstanceSide
		ifTrue: [ #initializeInstanceSideTranspiler: ] ifFalse: [ #initializeClassSideTranspiler: ].
	(targetClass instanceSide respondsTo: initializer) ifTrue: [
		targetClass instanceSide perform: initializer with: self
	]
	"

]

{ #category : #accessing }
SWClass >> transpilerClass [

	^ self pool transpilerClass
]
