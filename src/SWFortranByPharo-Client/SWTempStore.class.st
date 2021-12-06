Class {
	#name : #SWTempStore,
	#superclass : #Object,
	#instVars : [
		'payload',
		'names',
		'currentName'
	],
	#category : #'SWFortranByPharo-Client-Analyzer'
}

{ #category : #enumerating }
SWTempStore >> detect: arg1 ifNone: arg2 [

	^ payload detect: arg1 ifNone: arg2
]

{ #category : #initialization }
SWTempStore >> initialize [

	super initialize.
	payload := OrderedCollection new
]

{ #category : #accessing }
SWTempStore >> method: arg1 [

	names := arg1 tempNames
]

{ #category : #private }
SWTempStore >> nextName [

	currentName := SWVariableInfo nextTemporalVariableNameOf: currentName.
	^ (names anySatisfy: [ :arg1 | arg1 = currentName ])
		  ifTrue: [ self nextName ]
		  ifFalse: [ currentName ]
]

{ #category : #removing }
SWTempStore >> pop [

	^ payload removeFirst
]

{ #category : #adding }
SWTempStore >> push: arg1 [

	(payload isNotEmpty and: [ payload last = arg1 ]) ifTrue: [ ^ false ].
	payload add: arg1.
	arg1 name isEmptyOrNil ifFalse: [ ^ false ].
	arg1 name: self nextName.
	^ true
]
