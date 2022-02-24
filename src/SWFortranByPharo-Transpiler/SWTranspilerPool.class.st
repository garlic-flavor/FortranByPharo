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

{ #category : #'as yet unclassified' }
SWTranspilerPool >> initialize_Boolean: ct [
	ct
		senderTranspilerOf: #ifTrue:ifFalse: is: [ :transpiler | transpiler putIfTrueIfFalse ];
		senderTranspilerOf: #ifTrue: is: [ :transpiler | transpiler putIfTrue ]

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
