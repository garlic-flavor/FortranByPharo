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

{ #category : #constants }
SWTranspilerPool class >> initializersHeader [
	^ 'transpile_'
]

{ #category : #constants }
SWTranspilerPool class >> mangleClass [
	^ self subclassResponsibility 
]

{ #category : #constants }
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

{ #category : #private }
SWTranspilerPool >> newClassInfo: aClass [
	^ (super newClassInfo: aClass)
		classInfo: (self global getClassInfo: aClass);
		yourself
]

{ #category : #private }
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

{ #category : #initialization }
SWTranspilerPool >> transpile_Behavior: ct [
	ct
		senderTranspilerOf: #new is: [ :transpiler | transpiler putNew ]
]

{ #category : #initialization }
SWTranspilerPool >> transpile_BlockClosure: ct [
	ct
		senderTranspilerOf: #on:do: is: [ :bt | bt putOnDo ];
		senderTranspilerOf: #ensure: is: [ :bt | bt putEnsure ];
		senderTranspilerOf: #value: is: [ :bt | bt putCall ]
]

{ #category : #initialization }
SWTranspilerPool >> transpile_Boolean: ct [
	ct
		senderTranspilerOf: #ifTrue:ifFalse: is: [ :bt | bt putIfTrueIfFalse: true];
		senderTranspilerOf: #ifFalse:ifTrue: is: [ :bt | bt putIfTrueIfFalse: false ];
		senderTranspilerOf: #ifTrue: is: [ :bt | bt putIfTrue: true ];
		senderTranspilerOf: #ifFalse: is: [ :bt | bt putIfTrue: false ]


]

{ #category : #'as yet unclassified' }
SWTranspilerPool >> transpile_Dictionary: cdt [
	cdt
		senderTranspilerOf: #at:put: is: [ :mbt | mbt putAtPut ];
		senderTranspilerOf: #at:ifAbsent: is: [ :mbt | mbt putAtIfAbsent ]

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
		senderTranspilerOf: #yourself is: [ :mbt |	mbt putYourself ];
		senderTranspilerOf: #= is: [ :mbt | mbt putOpBinaryWith: '==' ];
		senderTranspilerOf: #~= is: [ :mbt | mbt putOpBinaryWith: '!=' ]

]

{ #category : #initialization }
SWTranspilerPool >> transpile_ProtoObject: ct [
	ct
		senderTranspilerOf: #ifNotNil:ifNil: is: [ :bt | bt putIfNotNilIfNil: true ];
		senderTranspilerOf: #ifNil: is: [ :bt | bt putIfNotNil: false ];
		senderTranspilerOf: #ifNotNil: is: [ :bt | bt putIfNotNil: true ];
		senderTranspilerOf: #class is: [ :bt | bt putSelfClass ];
		senderTranspilerOf: #flag: is: [ :bt | bt stream putComment: bt node children last value; preventDelimiter; preventNewline  ]
]

{ #category : #'as yet unclassified' }
SWTranspilerPool >> transpile_Stream: ct [
	ct
		senderTranspilerOf: #<< is: [ :mbt | mbt putMessageWithSelector: 'write' ]

]

{ #category : #api }
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
