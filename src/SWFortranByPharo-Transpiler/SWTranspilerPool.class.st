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

{ #category : #api }
SWTranspilerPool >> newClassInfo: aClass [
	^ (super newClassInfo: aClass)
		classInfo: (self global getClassInfo: aClass);
		yourself
]

{ #category : #'as yet unclassified' }
SWTranspilerPool >> predefinedSenderTranspiler: aSender [
	aSender method ifNil: [ ^ nil ].
	^ (self getClassInfo: aSender method methodClass)
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
	cdt := (self getClassInfo: aClass).
	cdt isTranspiled ifTrue: [ ^ self ].
	cdt transpile
	

]

{ #category : #'as yet unclassified' }
SWTranspilerPool >> transpile: aMethod with: operands [
	|ex receiver bt|
	ex := (self global decode: (SWSenderInfo new
		method: aMethod;
		operands: operands;
		yourself)) expression.
	receiver := operands first value instanceSide.
	self getClassInfo: receiver.
	(receiver respondsTo: #solveDependenciesUsing:) ifTrue: [
		receiver solveDependenciesUsing: self
	].
	self global remove: ex senderInfo.
	self transpile: aMethod methodClass instanceSide.
	self transpile: receiver.
	bt := self class methodBodyTranspilerClass new
		expression: ex;
		pool: self;
		yourself.
	bt transpile.

]

{ #category : #'as yet unclassified' }
SWTranspilerPool >> transpileBody: aMethod with: operands [
	|ex bt|
	ex := (self global decode: (SWSenderInfo new
		method: aMethod;
		operands: operands;
		yourself)) expression.
	bt := self class methodBodyTranspilerClass new
		expression: ex;
		pool: self;
		yourself.
	bt transpile.
	^ self stream contents.

]

{ #category : #initialization }
SWTranspilerPool >> transpile_Behavior: ct [
	ct
		senderTranspilerOf: #new is: [ :transpiler |  transpiler putNew ]
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
