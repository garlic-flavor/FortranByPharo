"
SWClass represents a Pharo class in SWGlobal.

"
Class {
	#name : #SWClassInfo,
	#superclass : #SWClassBase,
	#instVars : [
		'slot',
		'methods',
		'predefined'
	],
	#category : #'SWFortranByPharo-Analyzer-Analyzer'
}

{ #category : #constants }
SWClassInfo class >> expressionClass [
	^ SWExpression
]

{ #category : #private }
SWClassInfo >> addSlotAbout: aClass [
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
SWClassInfo >> declareMethod: aName asReturn: rType [
	self predefined at: aName put: [ :operands |
		rType
	]

]

{ #category : #api }
SWClassInfo >> declareMethodAsBinaryOperator: aName [

	self predefined at: aName put: [ :operands |
		operands first
	]

]

{ #category : #api }
SWClassInfo >> declareMethodAsCompareOperator: aName [
	self predefined at: aName put: [ :operands |
		Boolean
	]

]

{ #category : #api }
SWClassInfo >> declareMethodReturnsFirstArgument: aName [
	self predefined at: aName put: [ :operands |
		operands second
	]

]

{ #category : #api }
SWClassInfo >> declareMethodReturnsFirstArgumentsElement: aName [
	self predefined at: aName put: [ :operands |
		operands second elementType
	]

]

{ #category : #api }
SWClassInfo >> declareMethodReturnsFirstOrSecondArgument: aName [
	self predefined at: aName put: [ :operands |
		SWValue new
			<< operands second;
			<< operands third;
			yourself
	]

]

{ #category : #api }
SWClassInfo >> declareMethodReturnsFirstOrSecondArgumentsElement: aName [
	self predefined at: aName put: [ :operands |
		SWValue new
			<< operands second elementType;
			<< operands third elementType;
			yourself
	]

]

{ #category : #api }
SWClassInfo >> declareMethodReturnsReceiver: aName [
	self predefined at: aName put: [ :operands |
		operands first
	]

]

{ #category : #api }
SWClassInfo >> declareMethodReturnsReceiverOrFirstArgument: aName [
	self predefined at: aName put: [ :operands |
		SWValue new
			<< operands first;
			<< operands second;
			yourself
	]

]

{ #category : #api }
SWClassInfo >> declareMethodReturnsReceiverOrFirstArgumentsElement: aName [
	self predefined at: aName put: [ :operands |
		SWValue new
			<< operands first;
			<< operands second elementType;
			yourself
	]

]

{ #category : #api }
SWClassInfo >> declareMethodReturnsReceiversClass: aName [
	self predefined at: aName put: [ :operands |
		operands first value classSide
	]

]

{ #category : #api }
SWClassInfo >> declareMethodReturnsReceiversElement: aName [
	self predefined at: aName put: [ :operands |
		operands first elementType
	]

]

{ #category : #api }
SWClassInfo >> declareMethodReturnsReceiversInstance: aName [
	self predefined at: aName put: [:operands |
		operands first value instanceSide
	]

]

{ #category : #api }
SWClassInfo >> declareMethodReturnsSecondArgument: aName [
	self predefined at: aName put: [ :operands |
		operands third
	]

]

{ #category : #api }
SWClassInfo >> declareMethodReturnsSecondArgumentsElement: aName [
	self predefined at: aName put: [ :operands |
		operands third elementType
	]

]

{ #category : #'as yet unclassified' }
SWClassInfo >> declareSlot: aName as: aType [
	self slot detect: [ :type | type name = aName ] ifFound: [ :type | type << aType ]
]

{ #category : #api }
SWClassInfo >> decode: aSenderInfo [
	^ self methods at: aSenderInfo ifAbsent: [
		self predefined at: aSenderInfo method selector ifPresent: [ :pre | |messageInfo|
			messageInfo := SWMessageInfo newFrom: aSenderInfo.
			messageInfo result << (pre cull: aSenderInfo operands).
			self methods at: aSenderInfo put: messageInfo.
		] ifAbsent: [ |methodInfo|
			methodInfo := self newExpression: aSenderInfo.
			self methods at: aSenderInfo put: methodInfo.
			methodInfo
				decode;
				yourself
		]
	]

]

{ #category : #accessing }
SWClassInfo >> methods [
	"A Set object consists of referenced methods."
	^ methods ifNil: [methods := Dictionary new ]
]

{ #category : #accessing }
SWClassInfo >> methods: anObject [

	methods := anObject
]

{ #category : #private }
SWClassInfo >> newExpression: aSenderInfo [
	^ self class expressionClass new
		pool: self pool;
		slot: self slot copy;
		method: aSenderInfo method;
		operands: aSenderInfo operands;
		yourself
]

{ #category : #accessing }
SWClassInfo >> predefined [

	^ predefined ifNil: [ predefined := Dictionary new ]
]

{ #category : #accessing }
SWClassInfo >> predefined: anObject [

	predefined := anObject
]

{ #category : #api }
SWClassInfo >> remove: aSenderInfo [
	^ self methods removeKey: aSenderInfo ifAbsent: [ nil ]
]

{ #category : #api }
SWClassInfo >> setBreakpointOn: aName [
	self predefined at: aName put: [ :operands |
		self halt.
		UndefinedObject
	]

]

{ #category : #accessing }
SWClassInfo >> slot [
	^ slot ifNil: [
		slot := SWSlot new.
		self addSlotAbout: self targetClass.
		slot
	]
]

{ #category : #accessing }
SWClassInfo >> slot: anObject [

	slot := anObject
]
