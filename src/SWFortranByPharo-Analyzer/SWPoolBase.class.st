"
a base class of SWPool and SWTranspilerPool.
"
Class {
	#name : #SWPoolBase,
	#superclass : #Object,
	#instVars : [
		'payload',
		'owner'
	],
	#category : #'SWFortranByPharo-Analyzer-Analyzer'
}

{ #category : #constants }
SWPoolBase class >> classInfoClass [
	^ self subclassResponsibility 
]

{ #category : #private }
SWPoolBase class >> initializerFor: aClass [
	^ (String streamContents: [ :s |
		s
			<< self initializersHeader;
			<< aClass instanceSide name;
			<< (aClass isClassSide ifTrue: [ 'Class' ] ifFalse: [ '' ]);
			<< ':'
	]) asSymbol.

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

{ #category : #private }
SWPoolBase >> addInitializerIn: aClass receiver: receiverClass [
	"invoke aClass>>#initialize_Hoge: with Hoge class transpiler."
	 aClass classSide methodDict values select: [ :each |
		each selector beginsWith: self class initializersHeader
	] thenDo: [ :each ||name target isClassSide|
		name := each selector copyAfter: $_.
		isClassSide := name endsWith: 'Class:'.
		name := isClassSide ifTrue: [
			name allButLast: 6
		] ifFalse: [
			name allButLast
		].
		name = 'self' ifTrue: [ name := aClass instanceSide name ].
		target := Smalltalk globals at: name asSymbol.
		isClassSide ifTrue: [
			target := target classSide
		].
		each valueWithReceiver: receiverClass instanceSide arguments: {
			self getClassInfo: target
		}
	]
]

{ #category : #api }
SWPoolBase >> getClassInfo: aClass [
	^ self payload at: aClass ifAbsent: [|newCT|
		newCT := self newClassInfo: aClass.
		aClass isClassSide ifTrue: [
			self getClassInfo: aClass instanceSide
		].
		newCT
	]

]

{ #category : #private }
SWPoolBase >> initialize: aClassInfo asOf: aClass receiver: receiverClass [

	| initializer |
	aClass ifNil: [ ^ aClassInfo ].
	self initialize: aClassInfo asOf: aClass superclass receiver: receiverClass.
	initializer := self class initializerFor: aClass.
	(self respondsTo: initializer) ifTrue: [ 
		self perform: initializer with: aClassInfo ].
	aClass isInstanceSide ifTrue: [ self addInitializerIn: aClass receiver: receiverClass ].

	^ aClassInfo
]

{ #category : #private }
SWPoolBase >> newClassInfo: target [
	|ci|
	ci := self class classInfoClass new
		pool: self;
		targetClass: target;
		yourself.
	self payload at: target put: ci.
	self initialize: ci asOf: target receiver: target.
	^ ci
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
