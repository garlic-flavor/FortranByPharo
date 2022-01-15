"
I store temporal variables for cascading statement of Pharo.
"
Class {
	#name : #SWTempStore,
	#superclass : #Object,
	#instVars : [
		'payload',
		'names',
		'currentName'
	],
	#category : #'SWFortranByPharo-Transpiler-Common'
}

{ #category : #utils }
SWTempStore class >> nextTemporalVariableNameOf: prevName [
	^ prevName isEmptyOrNil ifTrue: [
		'a'
	] ifFalse: [|counter|
		counter := prevName last.
		counter := Character value: counter charCode + 1.
		(counter between: $a and: $z) ifTrue: [
			(prevName copyFrom: 1 to: prevName size - 1), counter asString
		] ifFalse: [
			(self nextTemporalVariableNameOf: (prevName copyFrom: 1 to: prevName size - 1)), 'a'
		]
	].
]

{ #category : #enumerating }
SWTempStore >> detect: detectBlock ifNone: noneBlock [
	self halt.
	^ payload detect: detectBlock ifNone: noneBlock
]

{ #category : #initialization }
SWTempStore >> initialize [ 
	super initialize.
	payload := OrderedCollection new
]

{ #category : #accessing }
SWTempStore >> method: aMethod [
	names := aMethod method tempNames
]

{ #category : #private }
SWTempStore >> nextName [
	currentName := self class nextTemporalVariableNameOf: currentName.
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
	aVariableInfo stackPos ifNotNil: [ ^ false ].
	aVariableInfo name isEmptyOrNil ifFalse: [ ^ false ].

	payload add: aVariableInfo.
	aVariableInfo name: self nextName.
	^ true

]
