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

	^ classSide ifNil: [
		classSide := self class new
			pool: self pool;
			targetClass: self targetClass classSide;
			yourself.
		classSide
			readyInitializers;
			yourself
	]
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

{ #category : #'public API' }
SWClass >> defineMethodBody: selector as: generator [
]

{ #category : #'public API' }
SWClass >> defineMethodSender: aSelector as: anInitializer [
]

{ #category : #api }
SWClass >> getSenderOf: aMethod with: args [
	|sender decoder|

	sender := self senderTranspilerClass new
		selector: aMethod selector;
		method: aMethod;
		operands: args;
		yourself.
	self methods associationAt: sender ifPresent: [ :assoc | ^ assoc key copy ].
	self senderInitializer at: sender selector ifPresent: [ :gen ||newS|
		newS := gen value: sender.
		decoder := self newDecoderOf: aMethod with: args.
		newS hasReturn ifFalse: [
			decoder decode.
			newS return: decoder return.
		].
		self methods at: newS put: decoder.
		^ newS copy
	].
	decoder := self newDecoderOf: aMethod with: args.
	self methods at: sender put: decoder.
	decoder decode.
	sender return: decoder return.
	^ sender copy

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
	^ self slot detect: [ :each | each isNotNil and: [ each name = aName ] ]  ifFound: [ :dummy | true ] ifNone: [ false ]
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
	].

]

{ #category : #initialization }
SWClass >> initialize_AbstractBinaryFileStream [
	self
		declareMethodReturnsReceiver: #position:
]

{ #category : #initialization }
SWClass >> initialize_AbstractFileReference [
	self
		declareMethodReturnsReceiver: #joinPath:;
		declareMethod: #contains: asReturn: Boolean;
		declareMethod: #exists asReturn: Boolean;
		declareMethodReturnsReceiver: #resolve;
		declareMethodReturnsReceiver: #relativeTo:;
		declareMethod: #fullName asReturn: String;
		declareMethod: #contents asReturn: String;
		declareMethodReturnsReceiver: #parent;
		declareMethodReturnsFirstArgumentsElement: #writeStreamDo:
]

{ #category : #initialization }
SWClass >> initialize_Behavior [
	self
		declareMethodReturnsReceiversInstance: #basicNew:;
		declareMethodReturnsReceiversInstance: #basicNew
]

{ #category : #initialization }
SWClass >> initialize_BinaryFileStream [
	self
		declareMethodReturnsReceiver: #truncate:
]

{ #category : #initialization }
SWClass >> initialize_BlockClosure [
	self
		declareMethodReturnsReceiversElement: #on:do:;
		declareMethodReturnsReceiversElement: #ensure:
]

{ #category : #initialization }
SWClass >> initialize_Boolean [ 
	self
		declareMethodReturnsFirstArgument: #ifTrue:;
 		declareMethodReturnsFirstArgument: #ifFalse:;
		declareMethodReturnsFirstArgument: #ifTrue:ifFalse:;
		declareMethodReturnsFirstArgument: #ifFalse:ifTrue:;
		declareMethodReturnsFirstArgument: #and:;
		declareMethodReturnsFirstArgument: #or:
]

{ #category : #initialization }
SWClass >> initialize_Character [
	self
		declareMethod: #asInteger asReturn: Integer
]

{ #category : #initialization }
SWClass >> initialize_CharacterClass [
	self
		declareMethodReturnsReceiversInstance: #value:
]

{ #category : #initialization }
SWClass >> initialize_Collection [
	self
		declareMethodReturnsSecondArgument: #detect:ifNone:;
		declareMethodReturnsFirstArgument: #inject:into:;
		declareMethod: #anySatisfy: asReturn: Boolean
]

{ #category : #initialization }
SWClass >> initialize_DateAndTimeClass [
	self
		declareMethodReturnsReceiversClass: #now
]

{ #category : #initialization }
SWClass >> initialize_Dictionary [
	self
		declareMethodReturnsSecondArgument: #at:put:;
		declareMethodReturnsSecondArgumentsElement: #at:ifAbsent:;
		declareMethodReturnsSecondArgumentsElement: #at:ifAbsentPut:;
		declareMethod: #includesKey: asReturn: Boolean;
		declareMethodReturnsReceiver: #stonOn:
]

{ #category : #initialization }
SWClass >> initialize_DictionaryClass [
	self
		declareMethodReturnsReceiversClass: #fromSton:
]

{ #category : #initialization }
SWClass >> initialize_Exception [
	self
		declareMethodReturnsReceiver: #signal
]

{ #category : #initialization }
SWClass >> initialize_IntervalClass [
	self
		setBreakpointOn: #new
]

{ #category : #initialization }
SWClass >> initialize_Magnitude [
	self
		declareMethodAsCompareOperator: #>=;
		declareMethodAsCompareOperator: #<=;
		declareMethodAsCompareOperator: #>;
		declareMethodAsCompareOperator: #<";
		defineMethodAsCompareOperator: #="

]

{ #category : #initialization }
SWClass >> initialize_Number [
	self
		declareMethodAsBinaryOperator: #+;
		declareMethodAsBinaryOperator: #-;
		declareMethodAsBinaryOperator: #*;
		declareMethodAsBinaryOperator: #/
		
]

{ #category : #initialization }
SWClass >> initialize_Object [
	self
		declareMethodAsCompareOperator: #=;
		declareMethod: #error: asReturn: nil;
		declareMethod: #printString asReturn: String;
		declareMethod: #size asReturn: Integer;
		declareMethod: #asString asReturn: String;
		declareMethodReturnsFirstArgument: #at:put:;
		declareMethod: #at: asReturn: Object;
		declareMethodReturnsReceiver: #putOn:;
		declareMethodReturnsReceiver: #assert:description:
]

{ #category : #initialization }
SWClass >> initialize_OrderedDictionary [
	self
		declareMethodReturnsReceiver: #initialize:
]

{ #category : #initialization }
SWClass >> initialize_Path [
	self
		declareMethodReturnsReceiver: #/;
		declareMethod: #basename asReturn: String;
		declareMethodReturnsReceiver: #withName:extension:;
		declareMethod: #pathString asReturn: String
]

{ #category : #initialization }
SWClass >> initialize_PathClass [
	self
		declareMethodReturnsReceiversInstance: #from:
]

{ #category : #initialization }
SWClass >> initialize_ProtoObject [
	self
		declareMethodAsCompareOperator: #==;
		declareMethodReturnsReceiversClass: #class;
		declareMethodReturnsFirstArgument: #ifNil:;
		declareMethodReturnsFirstArgument: #ifNotNil:;
		declareMethodReturnsFirstArgument: #ifNil:ifNotNil;
		declareMethodReturnsFirstArgument: #ifNotNil:ifNil:
]

{ #category : #initialization }
SWClass >> initialize_STONClass [
	self
		declareMethod: #jsonWriter asReturn: STONWriter;
		declareMethod: #fromString: asReturn: Object
]

{ #category : #initialization }
SWClass >> initialize_SWStdClass [
	self
		setBreakpointOn: #haltOnDecoding
]

{ #category : #initialization }
SWClass >> initialize_SWTypeClass [
	self
		declareMethod: #declare:as: asReturn: Association
]

{ #category : #initialization }
SWClass >> initialize_Semaphore [
	self
		declareMethodReturnsReceiver: #wait;
		declareMethodReturnsReceiver: #signal
]

{ #category : #initialization }
SWClass >> initialize_SequenceableCollection [
	self
		declareMethodReturnsReceiver: #,;
		declareMethodReturnsReceiver: #collect:;
		declareMethod: #indexOf:startingAt:ifAbsent: asReturn: Integer
]

{ #category : #initialization }
SWClass >> initialize_SequenceableCollectionClass [
	self
		declareMethodReturnsReceiversInstance: #streamContents:

]

{ #category : #initialization }
SWClass >> initialize_Set [
	self
		declareMethodReturnsFirstOrSecondArgument: #remove:ifAbsent:;
		declareMethodReturnsFirstArgument: #add:;
		declareMethod: #includes: asReturn: Boolean
]

{ #category : #initialization }
SWClass >> initialize_SmallDictionary [
	self
		declareMethodReturnsSecondArgument: #at:put:;
		declareMethodReturnsSecondArgument: #at:ifAbsent:;
		declareMethod: #includesKey: asReturn: Boolean
]

{ #category : #initialization }
SWClass >> initialize_String [
	self
		declareMethodReturnsReceiver: #trimLeft:right:;
		declareMethodReturnsReceiver: #asLowercase;
		declareMethod: #asZnUrl asReturn: ZnUrl;
		declareMethod: #beginsWith: asReturn: Boolean;
		declareMethod: #endsWith: asReturn: Boolean;
		declareMethodReturnsReceiver: #printOn:
]

{ #category : #initialization }
SWClass >> initialize_StringClass [
	self
		declareMethodReturnsReceiversInstance: #crlf;
		declareMethodReturnsReceiversInstance: #with:
]

{ #category : #initialization }
SWClass >> initialize_TestAsserter [
	self
		declareMethodReturnsReceiver: #assert:description:
]

{ #category : #initialization }
SWClass >> initialize_TestCaseClass [
	self
		declareMethod: #allTestSelectors asReturn: OrderedCollection
]

{ #category : #initialization }
SWClass >> initialize_ThreadSafeTranscript [
	self
		declareMethodReturnsFirstArgument: #nextPutAll:;
		declareMethodReturnsFirstArgument: #nextPut:;
		declareMethodReturnsReceiver: #endEntry;
		declareMethodReturnsFirstArgument: #critical:
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
SWClass >> newDecoderOf: aMethod with: args [
	|decoder|
	decoder := (self transpilerClass new: aMethod with: args)
		classInfo: self;
		pool: self pool;
		logger: self pool logger;
		haltList: self pool owner haltList;
		yourself.
	self decoderInitializer at: aMethod selector ifPresent: [ :ini |
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

{ #category : #'as yet unclassified' }
SWClass >> readyInitializers [
	self initialize: self targetClass.
	self pool addInitializerIn: self targetClass

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
