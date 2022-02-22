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

{ #category : #'as yet unclassified' }
SWPoolBase class >> classDispatcherClass [
	^ self subclassResponsibility 
]

{ #category : #private }
SWPoolBase class >> initializerFor: target [
	^ (String streamContents: [ :s |
		s
			<< 'initialize_';
			<< target instanceSide name;
			<< (target isClassSide ifTrue: [ 'Class' ] ifFalse: [ '' ]);
			<< ':'
	]) asSymbol.

]

{ #category : #'as yet unclassified' }
SWPoolBase class >> initializersKey [
	^ self subclassResponsibility
]

{ #category : #private }
SWPoolBase >> addInitializerIn: aClass [
	"invoke aClass>>#initialize_Hoge: with Hoge class transpiler."
	 aClass classSide methodDict values select: [ :each |
		each selector beginsWith: self class initializersKey
	] thenDo: [ :each ||name target|
		name := each selector copyAfter: $_.
		name := (each selector endsWith: 'Class:') ifTrue: [
			name copyUpToLast: $C
		] ifFalse: [
			name copyUpToLast: $:
		].
		name = 'self' ifTrue: [ name := aClass instanceSide name ].
		target := Smalltalk globals at: name asSymbol.
		(each selector endsWith: 'Class:') ifTrue: [
			target := target classSide
		].
		each valueWithReceiver: aClass instanceSide arguments: {
			self getClassDispatcher: target
		}
	]
]

{ #category : #private }
SWPoolBase >> getClassDispatcher: aClass [
	^ self payload at: aClass ifAbsent: [|newCT|
		newCT := self newClassDispatcher: aClass.
		aClass isClassSide ifTrue: [
			self getClassDispatcher: aClass instanceSide
		].
		newCT
	]

]

{ #category : #private }
SWPoolBase >> initialize: aClassDispatcher asOf: aClass [
	|initializer|
	aClass ifNil: [ ^ aClassDispatcher ].
	self initialize: aClassDispatcher asOf: aClass superclass.
	initializer := self class initializerFor: aClass.
	(self respondsTo: initializer) ifTrue: [
		self perform: initializer with: aClassDispatcher
	].
	^ aClassDispatcher
]

{ #category : #private }
SWPoolBase >> newClassDispatcher: target [
	|ct|
	ct := self class classDispatcherClass new
		pool: self;
		targetClass: target;
		yourself.
	self payload at: target put: ct.
	self initialize: ct asOf: target.
	target isInstanceSide ifTrue: [ self addInitializerIn: target ].
	^ ct
]

{ #category : #accessing }
SWPoolBase >> owner [

	^ owner
]

{ #category : #accessing }
SWPoolBase >> owner: anObject [

	owner := anObject
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
