"
I add a functionality to access queries of URI
"
Class {
	#name : #SWWebSocket,
	#superclass : #ZnWebSocket,
	#instVars : [
		'uri'
	],
	#category : #'SWFortranByPharo-ClientServer-Server'
}

{ #category : #accessing }
SWWebSocket >> uri [

	^ uri
]

{ #category : #accessing }
SWWebSocket >> uri: anObject [

	uri := anObject
]
