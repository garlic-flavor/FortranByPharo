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
	#category : #'SWFortranByPharo-Client-Analyzer'
}

{ #category : #'as yet unclassified' }
SWClass class >> installClassInfoBuilderFor: aClass [
	|pool|
	self halt.
	pool := SWPool new
		transpilerClass: SWStackAnalyzer;
		onClassAdded: [ :c |
			Transcript show: 'class: '; show: c targetClass name; cr
		];
		onMethodAdded: [ :mi |
			Transcript show: 'method: '; show: mi method selector; cr.
			mi classInfo isToTranspile ifTrue: [ mi decode ]
		];
		yourself.
	aClass methodDict valuesDo: [ :method |
		(pool new: method with: {aClass}) decode
	].
	self flag: #toImplement.
	^ pool payload at: aClass instanceSide
]

{ #category : #'as yet unclassified' }
SWClass >> defineMethod: aName as: rType [
	self generator at: aName put: [ :aCallee |
		(SWCompiledCodeInfo newFrom: aCallee)
			return: (SWVariableTypeInfo new: rType with: SWType userSpecifyingPriority);
			markAsDecoded;
			yourself.
	]

]

{ #category : #'as yet unclassified' }
SWClass >> defineMethodReturnsFirstArgument: aName [
	|method info ret|

	method := aName class = CompiledMethod ifTrue: [ aName ] ifFalse: [ self targetClass>>aName ].
	info := SWCompiledCodeInfo new
		method: method;
		markAsDecoded;
		yourself.
	ret := SWVariableTypeInfo new
		priority: SWType argumentTypePriority;
		yourself.
	(info stack at: 1) << ret.
	info return << ret.
	^ self methods at: method put: info

]

{ #category : #'as yet unclassified' }
SWClass >> defineMethodReturnsReceiver: aName [
	self generator at: aName put: [ :aCallee |
		(SWCompiledCodeInfo newFrom: aCallee)
			return: aCallee stack first;
			markAsDecoded;
			yourself
	]

]

{ #category : #'as yet unclassified' }
SWClass >> defineMethodReturnsReceiversInstance: aName [
	self generator at: aName put: [:aCallee |
		(SWCompiledCodeInfo newFrom: aCallee)
			return: (SWVariableTypeInfo new: aCallee receiverClass instanceSide);
			markAsDecoded;
			yourself.
	]

]

{ #category : #'as yet unclassified' }
SWClass >> definedMethod: aCallee ifAbsent: absentBlock [

	^ self generator at: aCallee method selector ifPresent: [ :gen |
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
	^ self slot detect: [ :each | each name = aName ]

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

{ #category : #accessing }
SWClass >> newMethodTranspiler: aMethod with: args [
	|callee|
	callee := SWCalleeInfo new: aMethod with: args.

	^ self methods detect: [ :one | one = callee ] ifNone: [|transpiler|
		transpiler := self definedMethod: callee ifAbsent: [
			(self transpilerClass newFrom: callee)
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

{ #category : #printing }
SWClass >> printInitializerOn: aStream [
	self halt.
	aStream
		<< 'predefinedClassInfo'; cr;
		tab; << '^ '; << self class name; space; << 'new'; cr;
		tab; tab; << 'targetClass: '; << self targetClass name; << ';'; cr;
		tab; tab; << 'yourself'
]

{ #category : #printing }
SWClass >> printOn: aStream [
	self putOn: aStream
]

{ #category : #streaming }
SWClass >> putOn: aStream [
	aStream << self targetClass name
]

{ #category : #'code generation - accessing' }
SWClass >> ready [
	|initializer|
	initializer := targetClass isInstanceSide
		ifTrue: [ #initializeInstanceSideTranspiler: ] ifFalse: [ #initializeClassSideTranspiler: ].
	(targetClass classSide methodDict includesKey: initializer) ifTrue: [
		(targetClass classSide >> initializer) valueWithReceiver: targetClass arguments: { self }
	].

]

{ #category : #'as yet unclassified' }
SWClass >> readyGenerator [
	self
		defineMethod: #= as: Boolean;
		defineMethod: #== as: Boolean;
		defineMethod: #~= as: Boolean;
		defineMethod: #< as: Boolean;
		defineMethodReturnsReceiver: #+;
		defineMethodReturnsReceiver: #-;
		defineMethodReturnsReceiver: #error:;
		defineMethodReturnsReceiversInstance: #basicNew;
		defineMethodReturnsReceiversInstance: #basicNew:

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

{ #category : #'as yet unclassified' }
SWClass >> typeOf: aName is: aType [
	self halt.
	(self getVariableInfoOf: aName)
		type: aType

]
