"
I hold type information about a class to transpile.

"
Class {
	#name : #SWClassInfo,
	#superclass : #Object,
	#instVars : [
		'targetClass',
		'members',
		'sourceHash',
		'slot',
		'pool'
	],
	#category : #'SWFortranByPharo-Client-Analyzer'
}

{ #category : #'as yet unclassified' }
SWClassInfo class >> installClassInfoBuilderFor: aClass [
	|pool|
	self halt.
	self flag: #toRemove.
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
		(aClass slots anySatisfy: [ :slot | slot isWrittenIn: method ]) ifTrue: [
			(pool new: method with: {aClass}) decode
		]
	].
	^ pool payload at: aClass
]

{ #category : #adding }
SWClassInfo >> addMember: aMethodInfo [
	"Add aMethodInfo to my list to be transpiled."
	^ self addMember: aMethodInfo ifAbsent: nil.

]

{ #category : #adding }
SWClassInfo >> addMember: aMethodInfo ifAbsent: absentBlock [
	"Add aMethodInfo to my list to be transpiled."
	
	^ self members at: aMethodInfo mangledName ifPresent: [ :mi |
		mi
	] ifAbsent: [
		aMethodInfo classInfo: self.
		self members at: aMethodInfo mangledName put: aMethodInfo.
		absentBlock value.
		aMethodInfo
	].

]

{ #category : #accessing }
SWClassInfo >> getVariableInfoAtOffset: offset [
	"Return SWVariableInfo in slots at offset."
	^ self slot atOffset: offset.
]

{ #category : #accessing }
SWClassInfo >> getVariableInfoOf: aName [
	"Return SWVariableInfo searched by its name."
	^ self slot detect: [ :each | each name = aName ]

]

{ #category : #testing }
SWClassInfo >> isToTranspile [
	^ self targetClass classSide methodDict includesKey: #toTranspile
]

{ #category : #accessing }
SWClassInfo >> members [
	"A Dictionary that contains SWMethodInfo to be transpiled, with its mangled name as key."

	^ members ifNil: [ members := Dictionary new ]
]

{ #category : #accessing }
SWClassInfo >> members: anObject [

	members := anObject
]

{ #category : #'as yet unclassified' }
SWClassInfo >> method: aName arguments: args is: rType [
	self addMember: (SWCompiledCodeInfo new
		method: aName;
		types: args;
		return: (SWVariableInfo new
			type: rType;
			yourself
		);
		yourself)
	
]

{ #category : #accessing }
SWClassInfo >> pool [

	^ pool
]

{ #category : #accessing }
SWClassInfo >> pool: anObject [

	pool := anObject
]

{ #category : #printing }
SWClassInfo >> printInitializerOn: aStream [
	aStream
		<< 'predefinedClassInfo'; cr;
		tab; << '^ '; << self class name; space; << 'new'; cr;
		tab; tab; << 'targetClass: '; << self targetClass name; << ';'; cr;
		tab; tab; << 'yourself'
]

{ #category : #accessing }
SWClassInfo >> readySlotAt: index [
	self targetClass methodDict values select: [ :m | m writesField: index ] thenDo: [ :m |
		(self pool new: m with: { self targetClass }) decode
	]

]

{ #category : #accessing }
SWClassInfo >> slot [

	^ slot ifNil: [
		slot := SWSlot new.
		self targetClass slots do: [ :ids |
			(slot at: ids index)
				name: ids name;
				priority: SWVariableInfo defaultPriority;
				type: [
					self readySlotAt: ids index.
					(self slot at: ids index) type
				]
		].
		slot
	]
]

{ #category : #accessing }
SWClassInfo >> slot: anObject [

	slot := anObject
]

{ #category : #accessing }
SWClassInfo >> sourceHash [
	"Return an accumulated hash consists of whole source code of targetClass."

	^ sourceHash ifNil: [
		sourceHash := SHA256 hashMessage: ((self members collect: [:each |
			SHA256 hashMessage: each method sourceCode
		]) flattened)
	]
]

{ #category : #accessing }
SWClassInfo >> targetClass [

	^ targetClass
]

{ #category : #accessing }
SWClassInfo >> targetClass: anObject [

	targetClass := anObject
]

{ #category : #'as yet unclassified' }
SWClassInfo >> typeOf: aName is: aType [
	(self getVariableInfoOf: aName)
		type: aType

]
