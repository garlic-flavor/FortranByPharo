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

{ #category : #private }
SWPoolBase >> addInitializerIn: aClass [
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
		each valueWithReceiver: aClass instanceSide arguments: {
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
SWPoolBase >> initialize: aClassInfo asOf: aClass [

	| initializer |
	aClass ifNil: [ ^ aClassInfo ].
	self initialize: aClassInfo asOf: aClass superclass.
	initializer := self class initializerFor: aClass.
	(self respondsTo: initializer) ifTrue: [ 
		self perform: initializer with: aClassInfo ].
	aClass isInstanceSide ifTrue: [ self addInitializerIn: aClass ].

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
	self initialize: ci asOf: target.
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
