"
a base class of SWGlobal and SWTranspilerPool.
"
Class {
	#name : #SWPoolBase,
	#superclass : #Object,
	#instVars : [
		'payload',
		'owner',
		'haltList'
	],
	#category : #'SWFortranByPharo-Analyzer-Analyzer'
}

{ #category : #constants }
SWPoolBase class >> classInfoClass [
	^ self subclassResponsibility 
]

{ #category : #private }
SWPoolBase class >> initializerFor: aClass [
	^ self
		initializerSelectorTrailed: aClass instanceSide name
		with: (aClass isClassSide ifTrue: [ 'Class' ] ifFalse: [ '' ] )

]

{ #category : #private }
SWPoolBase class >> initializerSelectorTrailed: trailer with: trailer2 [
	^ (String streamContents: [:s |
		s << self initializersHeader; << trailer; << trailer2; << ':'
	]) asSymbol
]

{ #category : #constants }
SWPoolBase class >> initializersHeader [
	^ self subclassResponsibility 
]

{ #category : #utils }
SWPoolBase class >> search: aSelector in: aClass [
	^ self search: aSelector in: aClass ifFound: [ :found | found ] ifNone: [ self error ]
]

{ #category : #utils }
SWPoolBase class >> search: selector in: aClass ifFound: foundBlock ifNone: noneBlock [
	aClass ifNil: [ ^ noneBlock value ].

	^ aClass methodDict at: selector ifPresent: [ :detected |
		foundBlock value: detected
	] ifAbsent: [
		self search: selector in: aClass superclass ifFound: foundBlock ifNone: noneBlock
	]

]

{ #category : #api }
SWPoolBase >> getClassInfo: aClass [
	^ self payload at: aClass ifAbsent: [ self newClassInfo: aClass ]

]

{ #category : #modifying }
SWPoolBase >> haltAt: aSymbol [
	self haltAt: aSymbol switch: true
]

{ #category : #modifying }
SWPoolBase >> haltAt: key switch: aBoolean [
	aBoolean ifTrue: [
		self haltList add: key
	] ifFalse: [
		self haltList remove: key ifAbsent: [  ]
	]
]

{ #category : #accessing }
SWPoolBase >> haltList [
	^ haltList ifNil: [ haltList := Set new ]
]

{ #category : #accessing }
SWPoolBase >> haltList: anObject [

	haltList := anObject
]

{ #category : #private }
SWPoolBase >> initialize: ci [
	|targetClass initializer|
	targetClass := ci targetClass.
	self initialize: ci asOf: targetClass.
	initializer := self class
		initializerSelectorTrailed: 'self'
		with: (targetClass isClassSide ifTrue: [ 'Class' ] ifFalse: [ '' ]).
	targetClass classSide methodDict at: initializer ifPresent: [ :init | 
		init valueWithReceiver: targetClass instanceSide arguments: { ci }
	].
	^ ci

]

{ #category : #private }
SWPoolBase >> initialize: aClassInfo asOf: aClass [
	| initializer |
	aClass ifNil: [ ^ self ].
	self initialize: aClassInfo asOf: aClass superclass.

	initializer := self class initializerFor: aClass.
	(self respondsTo: initializer) ifTrue: [ 
		self perform: initializer with: aClassInfo ].

]

{ #category : #private }
SWPoolBase >> newClassInfo: target [
	|ci|
	target isClassSide ifTrue: [ self getClassInfo: target instanceSide ].
	ci := self class classInfoClass new
		pool: self;
		targetClass: target;
		yourself.
	self payload at: target put: ci.
	^ self initialize: ci.

]

{ #category : #accessing }
SWPoolBase >> payload [

	^ payload ifNil: [ payload := Dictionary new ]
]

{ #category : #accessing }
SWPoolBase >> payload: anObject [

	payload := anObject
]

{ #category : #printing }
SWPoolBase >> printOn: aStream [
	self putOn: aStream.
]

{ #category : #streaming }
SWPoolBase >> putOn: aStream [
	aStream << $#; << (self hash % 16rFFFF) printStringHex
]
