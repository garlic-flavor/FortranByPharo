"
I hold type information about a class to transpile.

"
Class {
	#name : #SWClass,
	#superclass : #Object,
	#instVars : [
		'targetClass',
		'methods',
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

{ #category : #'as yet unclassified' }
SWClass >> method: aName arguments: args is: rType [
	self methods at: self targetClass>>aName put: (
		SWCompiledCodeInfo new
			method: self targetClass>>aName;
			return: rType;
			markAsDecoded;
			yourself)

]

{ #category : #accessing }
SWClass >> method: aMethod with: args [
	^ self methods at: aMethod ifPresent: [ :m |
		(m copy) types: args; yourself
	] ifAbsent: [|methodInfo|
		methodInfo := (self transpilerClass new: aMethod with: args)
			classInfo: self;
			pool: self pool;
			yourself.
		self methods at: aMethod put: methodInfo.
		(methodInfo copy)
			decode;
			yourself
	]
]

{ #category : #accessing }
SWClass >> methods [

	^ methods ifNil: [methods := Dictionary new ]
]

{ #category : #accessing }
SWClass >> methods: anObject [

	methods := anObject
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
		sourceHash := SHA256 hashMessage: ((self members collect: [:each |
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

	targetClass := anObject
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
