"
I have an information about a variable.

about, its type, const or not, and other properties.
"
Class {
	#name : #SWVariable,
	#superclass : #Object,
	#instVars : [
		'name',
		'payload',
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
	self payload << rightObject.
	self assignCounter: self assignCounter + 1
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

	^ assignCounter ifNil: [ assignCounter := 0 ]
]

{ #category : #accessing }
SWVariable >> assignCounter: anObject [

	assignCounter := anObject
]

{ #category : #accessing }
SWVariable >> elementType [
	^ self payload elementType
]

{ #category : #testing }
SWVariable >> hasProperty: aProperty [
	^ self properties includes: aProperty
]

{ #category : #comparing }
SWVariable >> hash [
	^ self payload hash
]

{ #category : #accessing }
SWVariable >> name [
	^ name
]

{ #category : #accessing }
SWVariable >> name: aName [
	name := aName
]

{ #category : #accessing }
SWVariable >> payload [

	^ payload ifNil: [ payload := SWValue new ]
]

{ #category : #accessing }
SWVariable >> payload: anObject [

	payload := anObject
]

{ #category : #printing }
SWVariable >> printOn: aStream [
	^ self putOn: aStream
]

{ #category : #accessing }
SWVariable >> priority [

	^ self payload priority

]

{ #category : #accessing }
SWVariable >> priority: anObject [

	^ self payload priority: anObject.
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
		<< self payload;
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

	^ self payload type
]

{ #category : #accessing }
SWVariable >> type: anObject [

	self payload type: anObject

]

{ #category : #accessing }
SWVariable >> value [
	^ self payload value
]
