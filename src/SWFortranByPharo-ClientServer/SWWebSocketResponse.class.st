"
I connect SWWebSocketDelegate to SWWebSocket
"
Class {
	#name : #SWWebSocketResponse,
	#superclass : #ZnWebSocketResponse,
	#instVars : [
		'uri'
	],
	#category : #'SWFortranByPharo-ClientServer-Server'
}

{ #category : #accessing }
SWWebSocketResponse >> uri [

	^ uri
]

{ #category : #accessing }
SWWebSocketResponse >> uri: anObject [

	uri := anObject
]

{ #category : #accessing }
SWWebSocketResponse >> useConnection: connection [
	"Hook method overwritten to give the receiver the chance to 
	keep using connection in the current thread/process after the server wrote the response.
	We start a conversation by instanciating a WebSocket and passing it to our continuation."
	
	| webSocket |
	webSocket := SWWebSocket onStream: connection.
	webSocket uri: self uri.
	self continuation value: webSocket
]
