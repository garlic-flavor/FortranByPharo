"
This is for to support non-continuous access from same client.
"
Class {
	#name : #SWSession,
	#superclass : #SWStd,
	#instVars : [
		'status',
		'instruction',
		'socket'
	],
	#category : #'SWFortranByPharo-Server-Server'
}

{ #category : #accessing }
SWSession class >> declarationFilter: aSymbol [
	^ super declarationFilter: aSymbol
]

{ #category : #'as yet unclassified' }
SWSession class >> rb_requirements [
	^ #()
]

{ #category : #accessing }
SWSession >> instruction [

	^ instruction
]

{ #category : #accessing }
SWSession >> instruction: anObject [

	instruction := anObject
]

{ #category : #accessing }
SWSession >> socket [

	^ socket
]

{ #category : #accessing }
SWSession >> socket: anObject [

	socket := anObject
]

{ #category : #accessing }
SWSession >> status [

	^ status ifNil: [ status := SWServerStatus new ]
]

{ #category : #accessing }
SWSession >> status: anObject [

	status := anObject
]
