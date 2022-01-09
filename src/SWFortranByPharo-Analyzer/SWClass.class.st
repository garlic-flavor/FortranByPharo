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
		'slot'
	],
	#category : #'SWFortranByPharo-Analyzer-Class'
}

{ #category : #api }
SWClass >> defineMethod: aName as: rType [
	self generator at: aName put: [ :aCallee |
		(self transpilerClass newFrom: aCallee)
			specifyReturnTypeAs: (rType isBlock ifTrue: [ rType value: aCallee ] ifFalse: [ rType ]);
			markAsDecoded;
			yourself
	]

]

{ #category : #api }
SWClass >> defineMethodReturnsFirstArgument: aName [
	self generator at: aName put: [ :aCallee |
		(self transpilerClass newFrom: aCallee)
			return: (aCallee stack at: 1);
			markAsDecoded;
			yourself
	]

]

{ #category : #api }
SWClass >> defineMethodReturnsReceiver: aName [
	self generator at: aName put: [ :aCallee |
		(self transpilerClass newFrom: aCallee)
			return: aCallee stack first;
			markAsDecoded;
			yourself
	]

]

{ #category : #api }
SWClass >> defineMethodReturnsReceiversClass: aName [
	self generator at: aName put: [:aCallee |
		(self transpilerClass newFrom: aCallee)
			return: (SWVariableTypeInfo new: aCallee receiverClass classSide);
			markAsDecoded;
			yourself.
	]

]

{ #category : #api }
SWClass >> defineMethodReturnsReceiversInstance: aName [
	self generator at: aName put: [:aCallee |
		(self transpilerClass newFrom: aCallee)
			return: (SWVariableTypeInfo new: aCallee receiverClass instanceSide);
			markAsDecoded;
			yourself.
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

	^ generator ifNil: [
		generator := Dictionary new.
		self readyGenerator.
		generator
	]
]

{ #category : #accessing }
SWClass >> generator: anObject [

	generator := anObject
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

{ #category : #testing }
SWClass >> isToTranspile [
	^ self targetClass classSide methodDict includesKey: #toTranspile
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
SWClass >> newMethodTranspiler: aCallee [

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

{ #category : #initialization }
SWClass >> ready [
	|initializer|
	initializer := targetClass isInstanceSide
		ifTrue: [ #initializeInstanceSideTranspiler: ] ifFalse: [ #initializeClassSideTranspiler: ].
	(targetClass classSide methodDict includesKey: initializer) ifTrue: [
		(targetClass classSide >> initializer) valueWithReceiver: targetClass arguments: { self }
	].

]

{ #category : #initialization }
SWClass >> readyGenerator [
	self
		defineMethod: #= as: Boolean;
		defineMethod: #== as: Boolean;
		defineMethod: #~= as: Boolean;
		defineMethod: #< as: Boolean;
		defineMethod: #> as: Boolean;
		defineMethod: #>= as: Boolean;
		defineMethod: #<= as: Boolean;
		defineMethodReturnsReceiver: #+;
		defineMethodReturnsReceiver: #*;
		defineMethodReturnsReceiver: #-;
		defineMethodReturnsReceiver: #error:;
		defineMethodReturnsReceiversInstance: #basicNew;
		defineMethodReturnsReceiversInstance: #basicNew:;
		defineMethodReturnsSecondArgument: #at:put:;
		defineMethodReturnsSecondArgument: #at:ifAbsent:;
		defineMethod: #asInteger as: Integer;
		defineMethod: #asString as: String

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
SWClass >> sourceHash [
	"Return an accumulated hash consists of whole source code of targetClass."

	^ sourceHash ifNil: [
		sourceHash := SHA256 hashMessage: ((self methods collect: [:each |
			SHA256 hashMessage: each method sourceCode
		]) flattened)
	]
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
