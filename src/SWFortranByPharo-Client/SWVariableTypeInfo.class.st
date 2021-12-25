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
		'assignCounter'
	],
	#category : #'SWFortranByPharo-Client-Analyzer'
}

{ #category : #'instance creation' }
SWVariableTypeInfo class >> new: aType [
	^ self new: aType with: nil
]

{ #category : #'instance creation' }
SWVariableTypeInfo class >> new: aType with: aPriority [
	^ self new
		<< aType;
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
	(rightObject class includesBehavior: SWVariableTypeInfo) ifTrue: [
		self type << rightObject type.
		self properties addAll: rightObject properties.
		self assignCounter: self assignCounter + 1.
	] ifFalse: [
		self type << rightObject
	]

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
SWVariableTypeInfo >> name [
	^ name
]

{ #category : #accessing }
SWVariableTypeInfo >> name: aName [
	name := aName
]

{ #category : #copying }
SWVariableTypeInfo >> postCopy [
	super postCopy.
	self type addContainer: self
]

{ #category : #printing }
SWVariableTypeInfo >> printOn: aStream [

	^ self putOn: aStream
]

{ #category : #accessing }
SWVariableTypeInfo >> priority [

	^ self type priority

]

{ #category : #accessing }
SWVariableTypeInfo >> priority: anObject [

	^ self type priority: anObject.
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
		<< (stackPos ifNil: [ $- ] ifNotNil: [ stackPos asString ]);
		<< $];
		space;
		<< name asString;
		space;
		<< $<;
		<< self type;
		<< $>;
		space;
		<< '<< ';
		<< self assignCounter asString
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

	type := anObject

]

{ #category : #accessing }
SWVariableTypeInfo >> value [
	^ self type value
]
