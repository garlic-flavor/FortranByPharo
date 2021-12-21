"
I have an information about a variable.
about, its type, const or not, and other properties.
"
Class {
	#name : #SWVariableTypeInfo,
	#superclass : #Object,
	#instVars : [
		'stackPos',
		'name',
		'type',
		'properties',
		'assignCounter',
		'priority'
	],
	#category : #'SWFortranByPharo-Client-Analyzer'
}

{ #category : #'as yet unclassified' }
SWVariableTypeInfo class >> declare: aName as: aType [
self halt.
	^ self new
		name: aName;
		type: aType;
		priority: self userSpecifiesTypePriority;
		yourself
]

{ #category : #'instance creation' }
SWVariableTypeInfo class >> newAs: aType [
	^ self new
		type: aType;
		yourself.
]

{ #category : #'instance creation' }
SWVariableTypeInfo class >> newAs: aType with: aPriority [
	^ self new
		type: aType;
		priority: aPriority;
		yourself.
]

{ #category : #utils }
SWVariableTypeInfo class >> nextTemporalVariableNameOf: prevName [
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

{ #category : #'accumulator ops' }
SWVariableTypeInfo >> << rightObject [
	self type << rightObject type.
	self properties addAll: rightObject properties.
	self assignCounter: self assignCounter + 1

]

{ #category : #adding }
SWVariableTypeInfo >> addProperty: aProp [
	self properties add: aProp
]

{ #category : #accessing }
SWVariableTypeInfo >> assignCounter [

	^ assignCounter ifNil: [ assignCounter := 0 ]
]

{ #category : #accessing }
SWVariableTypeInfo >> assignCounter: anObject [

	assignCounter := anObject
]

{ #category : #copying }
SWVariableTypeInfo >> copyAsSuper [
self halt.
	^ self copy
		type: [ self type superclass ];
		yourself.
]

{ #category : #accessing }
SWVariableTypeInfo >> easyValue [
	^ self type easyValue

]

{ #category : #testing }
SWVariableTypeInfo >> hasProperty: aProperty [
	^ self properties includes: aProperty
]

{ #category : #accessing }
SWVariableTypeInfo >> mangledName [
	^ self type mangledName
]

{ #category : #accessing }
SWVariableTypeInfo >> name [
	^ name
]

{ #category : #accessing }
SWVariableTypeInfo >> name: aName [
	name := aName
]

{ #category : #accessing }
SWVariableTypeInfo >> priority [

	^ self type priority

]

{ #category : #accessing }
SWVariableTypeInfo >> priority: anObject [
	self type priority: anObject
]

{ #category : #accessing }
SWVariableTypeInfo >> properties [

	^ properties ifNil: [ properties := Set new ]
]

{ #category : #accessing }
SWVariableTypeInfo >> properties: anObject [

	properties := anObject
]

{ #category : #accessing }
SWVariableTypeInfo >> property: propName [
	^ self properties at: propName ifAbsent: nil
]

{ #category : #printing }
SWVariableTypeInfo >> putOn: aStream [
	aStream
		<< $[;
		<< stackPos asString;
		<< $];
		space;
		<< name;
		space;
		<< $<;
		<< self type;
		<< $>;
		space;
		<< '<< ';
		<< assignCounter asString
]

{ #category : #removing }
SWVariableTypeInfo >> removeProperty: propName [
	properties remove: propName ifAbsent: [  ].
]

{ #category : #accessing }
SWVariableTypeInfo >> stackPos [

	^ stackPos
]

{ #category : #accessing }
SWVariableTypeInfo >> stackPos: anObject [

	stackPos := anObject
]

{ #category : #accessing }
SWVariableTypeInfo >> type [

	^ type ifNil: [ type := SWTypeGroup newFor: self ]
]

{ #category : #accessing }
SWVariableTypeInfo >> type: anObject [

	self type << anObject

]

{ #category : #accessing }
SWVariableTypeInfo >> value [
	^ self type value
]
