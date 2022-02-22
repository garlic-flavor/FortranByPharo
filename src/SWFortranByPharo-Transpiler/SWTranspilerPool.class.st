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

{ #category : #'as yet unclassified' }
SWTranspilerPool >> predefinedSenderTranspiler: aSender [
	aSender method ifNil: [ ^ nil ].
	^ (self getClassDispatcher: aSender method methodClass)
		predefinedSenderTranspiler: aSender method selector


]
