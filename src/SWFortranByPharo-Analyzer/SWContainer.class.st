"
SWContainer represents a container, like BlockClosure or Array, Dictionary and so on.
"
Class {
	#name : #SWContainer,
	#superclass : #SWType,
	#instVars : [
		'elementType'
	],
	#category : #'SWFortranByPharo-Analyzer-Type'
}

{ #category : #comparing }
SWContainer >> = right [
	^ super = right and: [ self elementType = right elementType ]
]

{ #category : #accessing }
SWContainer >> elementType [

	^ elementType
]

{ #category : #accessing }
SWContainer >> elementType: anObject [

	elementType := anObject
]

{ #category : #comparing }
SWContainer >> hash [
	^ { payload. elementType } hash
]

{ #category : #testing }
SWContainer >> isContainer [
	^ true
]

{ #category : #streaming }
SWContainer >> putOn: aStream [
	aStream << 'C<'.
	super putOn: aStream.
	aStream
		<< ':';
		<< elementType asString;
		 << '>'
]
