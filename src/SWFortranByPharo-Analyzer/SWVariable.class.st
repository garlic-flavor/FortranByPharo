"
I have an information about a variable.
about, its type, const or not, and other properties.
"
Class {
	#name : #SWVariable,
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
SWVariable class >> new: aType [
	^ self new: aType with: nil 
]

{ #category : #'instance creation' }
SWVariable class >> new: aType with: aPriority [
	^ self new
		<< aType;
		priority: aPriority;
		yourself.

]

{ #category : #'accumulator ops' }
SWVariable >> << rightObject [
	(rightObject class includesBehavior: SWVariable) ifTrue: [
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
SWVariable >> = right [
	^ self value = right value
]

{ #category : #adding }
SWVariable >> addProperty: aProp [
	self properties add: aProp
]

{ #category : #accessing }
SWVariable >> assignCounter [

	^ assignCounter ifNil: [ assignCounter := OrderedCollection new ]
]

{ #category : #accessing }
SWVariable >> elementType [
	^ self type elementType
]

{ #category : #testing }
SWVariable >> hasProperty: aProperty [
	^ self properties includes: aProperty
]

{ #category : #comparing }
SWVariable >> hash [
	^ self type hash
]

{ #category : #accessing }
SWVariable >> name [
	^ name
]

{ #category : #accessing }
SWVariable >> name: aName [
	name := aName
]

{ #category : #printing }
SWVariable >> printOn: aStream [

	^ self putOn: aStream
]

{ #category : #accessing }
SWVariable >> priority [

	^ self type priority

]

{ #category : #accessing }
SWVariable >> priority: anObject [

	^ self type priority: anObject.
]

{ #category : #accessing }
SWVariable >> properties [

	^ properties ifNil: [ properties := Set new ]
]

{ #category : #accessing }
SWVariable >> properties: anObject [

	properties := anObject
]

{ #category : #accessing }
SWVariable >> property: propName [
	^ self properties at: propName ifAbsent: nil
]

{ #category : #streaming }
SWVariable >> putOn: aStream [
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
SWVariable >> removeProperty: propName [
	properties remove: propName ifAbsent: [  ].
]

{ #category : #accessing }
SWVariable >> type [

	^ type ifNil: [ type := SWType new ]
]

{ #category : #accessing }
SWVariable >> type: anObject [

	type := anObject

]

{ #category : #accessing }
SWVariable >> value [
	^ self type value
]
