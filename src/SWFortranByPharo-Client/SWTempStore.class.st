"
I store temporal variables for cascading statements of Pharo.
"
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
SWTempStore >> detect: detectBlock ifNone: noneBlock [
	^ payload detect: detectBlock ifNone: noneBlock
]

{ #category : #initialization }
SWTempStore >> initialize [ 
	super initialize.
	payload := OrderedCollection new
]

{ #category : #accessing }
SWTempStore >> method: aMethod [
	names := aMethod tempNames
]

{ #category : #private }
SWTempStore >> nextName [
	currentName := SWVariableInfo nextTemporalVariableNameOf: currentName.
	^ (names anySatisfy: [ :each | each = currentName ]) ifTrue: [
		self nextName
	] ifFalse: [
		currentName
	]
]

{ #category : #removing }
SWTempStore >> pop [
	^ payload removeFirst
]

{ #category : #adding }
SWTempStore >> push: aVariableInfo [
	(payload isNotEmpty and: [ payload last = aVariableInfo ]) ifTrue: [ ^ false ].

	payload add: aVariableInfo.
	aVariableInfo name isEmptyOrNil ifFalse: [ ^ false ].
	aVariableInfo name: self nextName.
	^ true

]