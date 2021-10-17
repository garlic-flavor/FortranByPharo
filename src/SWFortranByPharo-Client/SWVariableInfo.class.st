"
I have an information about a variable.
about, its type, const or not, and other properties.
"
Class {
	#name : #SWVariableInfo,
	#superclass : #Object,
	#instVars : [
		'name',
		'type',
		'properties',
		'initialValue'
	],
	#classVars : [
		'temporalVariableName'
	],
	#category : #'SWFortranByPharo-Client-Analyzer'
}

{ #category : #initialization }
SWVariableInfo class >> named: aName typed: aType [
	^ self new
		name: aName;
		type: aType;
		yourself
]

{ #category : #generating }
SWVariableInfo class >> newTemporalVariableNameIn: aDict [
	self nextTemporalVariableName.
	^ (aDict includesKey: temporalVariableName) ifTrue: [
		self newTemporalVariableNameIn: aDict
	] ifFalse: [
		temporalVariableName
	]
]

{ #category : #generating }
SWVariableInfo class >> nextTemporalVariableName [
	^ temporalVariableName := self nextTemporalVariableNameOf: temporalVariableName 
]

{ #category : #generating }
SWVariableInfo class >> nextTemporalVariableNameOf: prevName [
	^ prevName ifNil: [
		'a'
	] ifNotNil: [|carryOver next|
		carryOver := 1.
		next := prevName collect: [ :each ||n|
			n := Character value: each charCode + carryOver.
			(n between: $a and: $z) ifTrue: [ 
				carryOver := 0.
				n
			] ifFalse: [
				carryOver := 1.
				$a
			].
		].
		0 = carryOver ifTrue: [
			next
		] ifFalse: [ 
			next, 'a'
		]
	]
]

{ #category : #initialization }
SWVariableInfo class >> resetTemporalVariableName [
	<script>
	temporalVariableName := nil
]

{ #category : #adding }
SWVariableInfo >> addProperty: aProp [
	self properties add: aProp
]

{ #category : #accessing }
SWVariableInfo >> const [
	^ (self properties includes: #const) or: [ self properties includes: #parameter ]
]

{ #category : #accessing }
SWVariableInfo >> const: aFlag [
	aFlag ifTrue: [
		self properties add: #const
	] ifFalse: [
		self properties remove: #const ifAbsent: [ ].
		self properties remove: #parameter ifAbsent: [  ].
	]

]

{ #category : #accessing }
SWVariableInfo >> initialValue [

	^ initialValue
]

{ #category : #accessing }
SWVariableInfo >> initialValue: anObject [

	initialValue := anObject
]

{ #category : #accessing }
SWVariableInfo >> name [
	^ name
]

{ #category : #accessing }
SWVariableInfo >> name: aName [
	name := aName
]

{ #category : #accessing }
SWVariableInfo >> properties [

	^ properties ifNil: [ properties := Set new add: #const; yourself ]
]

{ #category : #accessing }
SWVariableInfo >> properties: anObject [

	properties := anObject
]

{ #category : #accessing }
SWVariableInfo >> type [
	^ type ifNil: [ type := Object ]
]

{ #category : #accessing }
SWVariableInfo >> type: aClass [
	type := aClass
]
