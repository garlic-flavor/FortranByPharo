"
Transpilers pool.
"
Class {
	#name : #SWTranspilerPool,
	#superclass : #SWPoolBase,
	#category : #'SWFortranByPharo-Transpiler-Common'
}

{ #category : #accessing }
SWTranspilerPool class >> classDispatcherClass [
	^ SWClassDefinitionTranspiler
]

{ #category : #'as yet unclassified' }
SWTranspilerPool class >> initializersKey [
	^ 'transpile_'
]

{ #category : #initialization }
SWTranspilerPool >> initialize_Behavior: ct [
	ct
		senderTranspilerOf: #new is: [ :transpiler |  transpiler putNew ]
]

{ #category : #initialization }
SWTranspilerPool >> initialize_BlockClosure: ct [
	ct
		senderTranspilerOf: #on:do: is: [ :bt | bt putOnDo ]
]

{ #category : #'as yet unclassified' }
SWTranspilerPool >> initialize_Boolean: ct [
	ct
		senderTranspilerOf: #ifTrue:ifFalse: is: [ :bt | bt putIfTrueIfFalse: true];
		senderTranspilerOf: #ifFalse:ifTrue: is: [ :bt | bt putIfTrueIfFalse: false ];
		senderTranspilerOf: #ifTrue: is: [ :bt | bt putIfTrue: true ];
		senderTranspilerOf: #ifFalse: is: [ :bt | bt putIfTrue: false ]


]

{ #category : #initialization }
SWTranspilerPool >> initialize_Number: ct [
	ct
		senderTranspilerOf: #+ is: [ :bt | bt putOpBinary ];
		senderTranspilerOf: #- is: [ :bt | bt putOpBinary ];
		senderTranspilerOf: #* is: [ :bt | bt putOpBinary ];
		senderTranspilerOf: #/ is: [ :bt | bt putOpBinary ]

]

{ #category : #initialization }
SWTranspilerPool >> initialize_Object: ct [
	ct
		senderTranspilerOf: #yourself is: [ :transpiler |
			transpiler putYourself
		]
]

{ #category : #'as yet unclassified' }
SWTranspilerPool >> predefinedSenderTranspiler: aSender [
	aSender method ifNil: [ ^ nil ].
	^ (self getClassDispatcher: aSender method methodClass)
		predefinedSenderTranspiler: aSender method selector


]
