"
I am a pool of SWClassInfo.
"
Class {
	#name : #SWPool,
	#superclass : #Object,
	#instVars : [
		'payload',
		'owner'
	],
	#category : #'SWFortranByPharo-Analyzer-Analyzer'
}

{ #category : #utils }
SWPool class >> search: selector in: aClass [
	aClass ifNil: [ ^ nil ].

	^ aClass methodDict at: selector ifAbsent: [
			self search: selector in: aClass superclass
	]

]

{ #category : #api }
SWPool >> addInitializerIn: aClass [
	"invoke aClass>>$initialize_Hoge: with Hoge class transpiler."
	 aClass classSide methodDict values select: [ :each |
		each selector beginsWith: 'initialize_'
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
			self getClassTranspiler: target
		}
	]
]

{ #category : #api }
SWPool >> addTranspilerOf: aClass initialize: anInitializer [
	anInitializer cull: (self getClassTranspiler: aClass)
]

{ #category : #accessing }
SWPool >> classTranspilerClass [

	^ self owner class classTranspilerClass
]

{ #category : #accessing }
SWPool >> debugMode [

	^ self owner debugMode
]

{ #category : #enumerating }
SWPool >> detect: aNeedle ifFound: aBlock [

	^ self payload detect: aNeedle ifFound: aBlock
]

{ #category : #private }
SWPool >> getClassTranspiler: aClass [
	^ (aClass isClassSide ifTrue: [
		(self getClassTranspiler: aClass instanceSide) classSide
	] ifFalse: [
		self payload at: aClass ifAbsent: [|newCT|
			newCT := self classTranspilerClass new
					pool: self;
					targetClass: aClass;
					yourself.
			self payload at: aClass put: newCT.
			newCT
				readyInitializers;
				yourself
		]
	])

]

{ #category : #accessing }
SWPool >> logger [
	^ self owner logger
]

{ #category : #api }
SWPool >> newSenderOf: aSelector super: supered with: args [
	|method|
	method := self class search: aSelector
		in: (supered ifTrue: [ args receiver value superclass ] ifFalse: [ args receiver value ]).
	^ method ifNil: [ 
		self newUndefinedSenderOf: aSelector with: args
	] ifNotNil: [
		(self getClassTranspiler: method methodClass)
			getSenderOf: method with: args
	]
"		
	callee := SWCalleeInfo new: (method ifNotNil: [ method ] ifNil: [ aSelector ]) with: args.
	methodClass := (method ifNotNil: [ method methodClass ] ifNil: [ UndefinedObject ] ).
	^ (self getClassTranspiler: methodClass)
		getMethodTranspiler: callee
"

]

{ #category : #private }
SWPool >> newUndefinedSenderOf: aSelector with: args [
	self logger log: [ 'An unknown method detected: ', aSelector ].
	self debugMode ifTrue: [ self halt ].
	^ self senderTranspilerClass new
		selector: aSelector;
		operands: args;
		return: SWVariableTypeInfo new;
		yourself

]

{ #category : #accessing }
SWPool >> owner [

	^ owner
]

{ #category : #accessing }
SWPool >> owner: anObject [

	owner := anObject
]

{ #category : #accessing }
SWPool >> payload [

	^ payload ifNil: [ payload := Dictionary new ]
]

{ #category : #accessing }
SWPool >> payload: anObject [

	payload := anObject
]

{ #category : #printing }
SWPool >> printOn: aStream [
	self putOn: aStream.
]

{ #category : #streaming }
SWPool >> putOn: aStream [
	aStream << $#; << (self hash % 16rFFFF) printStringHex
]

{ #category : #accessing }
SWPool >> senderTranspilerClass [

	^ self owner class senderTranspilerClass
]

{ #category : #accessing }
SWPool >> transpilerClass [

	^ self owner class
]
