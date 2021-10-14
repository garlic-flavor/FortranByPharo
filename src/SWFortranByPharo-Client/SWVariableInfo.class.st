"
I have an information about a variable.
about, its type, const or not, and other properties.
"
Class {
	#name : #SWVariableInfo,
	#superclass : #Object,
	#instVars : [
		'properties'
	],
	#classVars : [
		'temporalVariableName'
	],
	#category : #'SWFortranByPharo-Client-Transpiler'
}

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

{ #category : #accessing }
SWVariableInfo >> name [
	^ self properties at: #name
]

{ #category : #accessing }
SWVariableInfo >> name: aName [
	self properties at: #name put: aName
]

{ #category : #accessing }
SWVariableInfo >> properties [

	^ properties ifNil: [ properties := Dictionary new ]
]

{ #category : #accessing }
SWVariableInfo >> properties: anObject [

	properties := anObject
]

{ #category : #accessing }
SWVariableInfo >> type [
	^ self properties at: #type ifAbsentPut: [ Object ]
]

{ #category : #accessing }
SWVariableInfo >> type: aClass [
	self properties at: #type put: aClass
]
