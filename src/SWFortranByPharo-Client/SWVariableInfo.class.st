"
I have an information about a variable.
about, its type, const or not, and other properties.
"
Class {
	#name : #SWVariableInfo,
	#superclass : #Object,
	#instVars : [
		'stackPos',
		'name',
		'type',
		'properties',
		'original',
		'initializer'
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

{ #category : #'instance creation' }
SWVariableInfo class >> newFrom: anTypeArray [
	^ anTypeArray collectWithIndex: [ :type :idx |
		self new
			type: type;
			stackPos: idx - 2;
			yourself.
	]
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

{ #category : #'accumulator ops' }
SWVariableInfo >> << rightObject [
	rightObject original ifNil: [
		self
			type: rightObject type;
			original: (rightObject stackPos ifNotNil: [rightObject] ifNil: [nil]).
		self properties addAll: rightObject properties
	] ifNotNil: [
		self << rightObject original
	]
		

]

{ #category : #adding }
SWVariableInfo >> addProperty: aProp [
	self properties add: aProp
]

{ #category : #testing }
SWVariableInfo >> hasExactType [
	^ type isNotNil
]

{ #category : #testing }
SWVariableInfo >> hasProperty: aProperty [
	^ self properties includes: aProperty
]

{ #category : #accessing }
SWVariableInfo >> initializer [

	^ initializer
]

{ #category : #accessing }
SWVariableInfo >> initializer: anObject [

	initializer := anObject
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
SWVariableInfo >> original [

	^ original
]

{ #category : #accessing }
SWVariableInfo >> original: anObject [

	original := anObject
]

{ #category : #accessing }
SWVariableInfo >> properties [

	^ properties ifNil: [ properties := Set new ]
]

{ #category : #accessing }
SWVariableInfo >> properties: anObject [

	properties := anObject
]

{ #category : #accessing }
SWVariableInfo >> property: propName [
	^ self properties at: propName ifAbsent: nil
]

{ #category : #removing }
SWVariableInfo >> removeProperty: propName [
	properties remove: propName ifAbsent: [  ].
]

{ #category : #accessing }
SWVariableInfo >> stackPos [

	^ stackPos
]

{ #category : #accessing }
SWVariableInfo >> stackPos: anObject [

	stackPos := anObject
]

{ #category : #accessing }
SWVariableInfo >> type [

	^ type ifNil: [
		self initializer ifNotNil: [
			type := self initializer value
		] ifNil: [ 
			nil
		]
	]
]

{ #category : #accessing }
SWVariableInfo >> type: anObject [

	type := anObject
]
