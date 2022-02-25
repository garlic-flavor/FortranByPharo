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
SWPoolBase class >> classProcedureClass [
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SWPoolBase class >> initializerFor: aClass [
	^ (String streamContents: [ :s |
		s
			<< self initializersHeader;
			<< '_';
			<< aClass instanceSide name;
			<< (aClass isClassSide ifTrue: [ 'Class' ] ifFalse: [ '' ]);
			<< ':'
	]) asSymbol.

]

{ #category : #'as yet unclassified' }
SWPoolBase class >> initializersHeader [
	^ self subclassResponsibility 
]

{ #category : #private }
SWPoolBase >> addInitializerIn: aClass [
	"invoke aClass>>#initialize_Hoge: with Hoge class transpiler."
	 aClass classSide methodDict values select: [ :each |
		each selector beginsWith: self class initializersHeader
	] thenDo: [ :each ||name target|
		name := each selector copyAfter: $_.
		name := (each selector endsWith: 'Class:') ifTrue: [
			name copyUpToLast: $C
		] ifFalse: [
			name copyUpToLast: $:
		].
		name = 'self' ifTrue: [ name := aClass instanceSide name ].
		name ifNotEmpty: [
			target := Smalltalk globals at: name asSymbol.
			(each selector endsWith: 'Class:') ifTrue: [
				target := target classSide
			].
			each valueWithReceiver: aClass instanceSide arguments: {
				self getClassProcedure: target
			}
		]
	]
]

{ #category : #api }
SWPoolBase >> getClassProcedure: aClass [
	^ self payload at: aClass ifAbsent: [|newCT|
		newCT := self newClassProcedure: aClass.
		aClass isClassSide ifTrue: [
			self getClassProcedure: aClass instanceSide
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
	aClass isInstanceSide ifTrue: [ self addInitializerIn: aClass ].

	^ aClassDispatcher
]

{ #category : #private }
SWPoolBase >> newClassProcedure: target [
	|ct|
	ct := self class classProcedureClass new
		pool: self;
		targetClass: target;
		yourself.
	self payload at: target put: ct.
	self initialize: ct asOf: target.
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
