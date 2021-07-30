"
This is for to support non-continuous access from same client.
"
Class {
	#name : #SWSession,
	#superclass : #Object,
	#instVars : [
		'status',
		'instruction'
	],
	#category : #'SWFortranByPharo-Server-Server'
}

{ #category : #accessing }
SWSession >> instruction [

	^ instruction ifNil: [ instruction := SWServerInstruction new ]
]

{ #category : #accessing }
SWSession >> instruction: anObject [

	instruction := anObject
]

{ #category : #accessing }
SWSession >> status [

	^ status ifNil: [ status := SWServerStatus new ]
]

{ #category : #accessing }
SWSession >> status: anObject [

	status := anObject
]
