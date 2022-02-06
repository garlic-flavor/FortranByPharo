"
SWContainerType represents a container, like BlockClosure or Array, Dictionary and so on.
"
Class {
	#name : #SWContainerType,
	#superclass : #SWType,
	#instVars : [
		'elementType'
	],
	#category : #'SWFortranByPharo-Analyzer-Type'
}

{ #category : #accessing }
SWContainerType >> elementType [

	^ elementType
]

{ #category : #accessing }
SWContainerType >> elementType: anObject [

	elementType := anObject
]

{ #category : #testing }
SWContainerType >> isContainer [
	^ true
]
