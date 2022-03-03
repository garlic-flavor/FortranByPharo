"
Transpilers pool.
"
Class {
	#name : #SWTranspilerPool,
	#superclass : #SWPoolBase,
	#instVars : [
		'global',
		'stream'
	],
	#category : #'SWFortranByPharo-Transpiler-Common'
}

{ #category : #'as yet unclassified' }
SWTranspilerPool class >> initializersHeader [
	^ 'transpile_'
]

{ #category : #'as yet unclassified' }
SWTranspilerPool class >> methodBodyTranspilerClass [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWTranspilerPool >> global [

	^ global ifNil: [ global := SWGlobal new ]
]

{ #category : #accessing }
SWTranspilerPool >> global: anObject [

	global := anObject
]

{ #category : #'code generation' }
SWTranspilerPool >> import: symbols from: module [
	self error; flag: #toRemove.
	self mainTranspiler
		putImport: symbols from: module;
		putStatementDelimiter;
		cr
]

{ #category : #accessing }
SWTranspilerPool >> mainTranspiler [

	^ mainTranspiler ifNil: [
		mainTranspiler := self class methodBodyTranspilerClass new
			pool: self;
			yourself
	]
]

{ #category : #accessing }
SWTranspilerPool >> mainTranspiler: anObject [

	mainTranspiler := anObject
]

{ #category : #api }
SWTranspilerPool >> newClassInfo: aClass [
	^ (super newClassInfo: aClass)
		classInfo: (self global getClassInfo: aClass);
		yourself
]

{ #category : #'as yet unclassified' }
SWTranspilerPool >> predefinedSenderTranspiler: aSender [
	aSender method ifNil: [ ^ nil ].
	^ (self getClassInfo: aSender receiverClass)
		predefinedSenderTranspiler: aSender method selector


]

{ #category : #accessing }
SWTranspilerPool >> stream [

	^ stream ifNil: [ stream := SWTranspilerStream new ]
]

{ #category : #accessing }
SWTranspilerPool >> stream: anObject [

	stream := anObject
]

{ #category : #'public API' }
SWTranspilerPool >> transpile: aClass [
	|cdt|
	self halt; flag: #toRemove.
	cdt := (self getClassInfo: aClass).
	cdt isTranspiled ifTrue: [ ^ self ].
	cdt transpile
	

]

{ #category : #'as yet unclassified' }
SWTranspilerPool >> transpileAsModule: aMethod with: operands [
	|ex receiver|
	self error; flag: #roRemove.
	receiver := operands first value instanceSide.
	(receiver respondsTo: #setUpTranspiler:) ifTrue: [
		receiver setUpTranspiler: self
	].
	ex := (self global decode: (SWSenderInfo new
		method: aMethod;
		operands: operands;
		yourself)) expression.
	self global remove: ex senderInfo.

	(receiver respondsTo: #solveDependencies:) ifTrue: [
		receiver solveDependencies: self
	].
	self transpile: aMethod methodClass instanceSide.
	self transpile: receiver.
	self mainTranspiler
		expression: ex;
		transpile
]

{ #category : #initialization }
SWTranspilerPool >> transpile_Behavior: ct [
	ct
		senderTranspilerOf: #new is: [ :transpiler | transpiler putNew ]
]

{ #category : #initialization }
SWTranspilerPool >> transpile_BlockClosure: ct [
	ct
		senderTranspilerOf: #on:do: is: [ :bt | bt putOnDo ]
]

{ #category : #'as yet unclassified' }
SWTranspilerPool >> transpile_Boolean: ct [
	ct
		senderTranspilerOf: #ifTrue:ifFalse: is: [ :bt | bt putIfTrueIfFalse: true];
		senderTranspilerOf: #ifFalse:ifTrue: is: [ :bt | bt putIfTrueIfFalse: false ];
		senderTranspilerOf: #ifTrue: is: [ :bt | bt putIfTrue: true ];
		senderTranspilerOf: #ifFalse: is: [ :bt | bt putIfTrue: false ]


]

{ #category : #initialization }
SWTranspilerPool >> transpile_Magnitude: ct [
	ct
		senderTranspilerOf: #< is: [ :bt | bt putOpBinary ]
]

{ #category : #initialization }
SWTranspilerPool >> transpile_Number: ct [
	ct
		senderTranspilerOf: #+ is: [ :bt | bt putOpBinary ];
		senderTranspilerOf: #- is: [ :bt | bt putOpBinary ];
		senderTranspilerOf: #* is: [ :bt | bt putOpBinary ];
		senderTranspilerOf: #/ is: [ :bt | bt putOpBinary ]

]

{ #category : #initialization }
SWTranspilerPool >> transpile_Object: ct [
	ct
		senderTranspilerOf: #yourself is: [ :transpiler |
			transpiler putYourself
		]
]

{ #category : #initialization }
SWTranspilerPool >> transpile_ProtoObject: ct [
	ct
		senderTranspilerOf: #ifNotNil:ifNil: is: [ :bt | bt putIfNotNilIfNil: true ];
		senderTranspilerOf: #ifNil: is: [ :bt | bt putIfNotNil: false ]
]

{ #category : #'as yet unclassified' }
SWTranspilerPool >> transpilerFor: aMethod with: operands [
	|sender expression|
	sender := SWSenderInfo new
		method: aMethod;
		operands: operands;
		yourself.
	expression := (self global decode: sender) expression.
	self global remove: sender.
	^ self class methodBodyTranspilerClass new
		pool: self;
		expression: expression;
		yourself

]
