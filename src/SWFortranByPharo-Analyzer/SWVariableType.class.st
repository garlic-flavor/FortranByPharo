"
I have an information about a variable.
about, its type, const or not, and other properties.
"
Class {
	#name : #SWVariableType,
	#superclass : #Object,
	#instVars : [
		'name',
		'type',
		'properties',
		'assignCounter'
	],
	#category : #'SWFortranByPharo-Analyzer-Type'
}

{ #category : #'instance creation' }
SWVariableType class >> new: aType [
	^ self new: aType with: nil 
]

{ #category : #'instance creation' }
SWVariableType class >> new: aType with: aPriority [
	^ self new
		<< aType;
		priority: aPriority;
		yourself.

]

{ #category : #'accumulator ops' }
SWVariableType >> << rightObject [
	(rightObject class includesBehavior: SWVariableType) ifTrue: [
		self priority < rightObject priority ifFalse: [ ^ rightObject ].
		self type: rightObject type.
		self properties addAll: rightObject properties.
		self assignCounter add: rightObject.
		^ rightObject
	].

	(rightObject class includesBehavior: SWType) ifTrue: [
		self type priority < rightObject priority ifTrue: [
			self type: rightObject
		].
		^ rightObject
	].

	self type << rightObject.
	^ rightObject

]

{ #category : #comparing }
SWVariableType >> = right [
	^ self value = right value
]

{ #category : #adding }
SWVariableType >> addProperty: aProp [
	self properties add: aProp
]

{ #category : #accessing }
SWVariableType >> assignCounter [

	^ assignCounter ifNil: [ assignCounter := OrderedCollection new ]
]

{ #category : #accessing }
SWVariableType >> elementType [
	^ self type elementType
]

{ #category : #testing }
SWVariableType >> hasProperty: aProperty [
	^ self properties includes: aProperty
]

{ #category : #comparing }
SWVariableType >> hash [
	^ self type hash
]

{ #category : #accessing }
SWVariableType >> name [
	^ name
]

{ #category : #accessing }
SWVariableType >> name: aName [
	name := aName
]

{ #category : #printing }
SWVariableType >> printOn: aStream [

	^ self putOn: aStream
]

{ #category : #accessing }
SWVariableType >> priority [

	^ self type priority

]

{ #category : #accessing }
SWVariableType >> priority: anObject [

	^ self type priority: anObject.
]

{ #category : #accessing }
SWVariableType >> properties [

	^ properties ifNil: [ properties := Set new ]
]

{ #category : #accessing }
SWVariableType >> properties: anObject [

	properties := anObject
]

{ #category : #accessing }
SWVariableType >> property: propName [
	^ self properties at: propName ifAbsent: nil
]

{ #category : #streaming }
SWVariableType >> putOn: aStream [
	aStream
		<< name asString;
		space;
		<< $<;
		<< self type;
		<< $>;
		space";
		<< '<< ';
		<< self assignCounter size asString;
		<< ' @';
		<< (self owner ifNil: [ 'none' ])"

]

{ #category : #removing }
SWVariableType >> removeProperty: propName [
	properties remove: propName ifAbsent: [  ].
]

{ #category : #accessing }
SWVariableType >> type [

	^ type ifNil: [ type := SWType new ]
]

{ #category : #accessing }
SWVariableType >> type: anObject [

	type := anObject

]

{ #category : #accessing }
SWVariableType >> value [
	^ self type value
]
