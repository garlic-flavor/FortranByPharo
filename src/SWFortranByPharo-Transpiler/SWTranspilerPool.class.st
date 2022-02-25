"
Transpilers pool.
"
Class {
	#name : #SWTranspilerPool,
	#superclass : #SWPoolBase,
	#category : #'SWFortranByPharo-Transpiler-Common'
}

{ #category : #'as yet unclassified' }
SWTranspilerPool class >> initializersHeader [
	^ 'transpile'
]

{ #category : #'as yet unclassified' }
SWTranspilerPool >> predefinedSenderTranspiler: aSender [
	aSender method ifNil: [ ^ nil ].
	^ (self getClassProcedure: aSender method methodClass)
		predefinedSenderTranspiler: aSender method selector


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
