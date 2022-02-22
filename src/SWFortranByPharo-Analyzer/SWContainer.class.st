"
SWContainerType represents a container, like BlockClosure or Array, Dictionary and so on.
"
Class {
	#name : #SWContainer,
	#superclass : #SWType,
	#instVars : [
		'elementType'
	],
	#category : #'SWFortranByPharo-Analyzer-Type'
}

{ #category : #accessing }
SWContainer >> elementType [

	^ elementType
]

{ #category : #accessing }
SWContainer >> elementType: anObject [

	elementType := anObject
]

{ #category : #testing }
SWContainer >> isContainer [
	^ true
]
