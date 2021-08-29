"
I am a WebSocket client
"
Class {
	#name : #SWClient,
	#superclass : #Object,
	#instVars : [
		'socket',
		'server'
	],
	#category : #'SWFortranByPharo-Client-Client'
}

{ #category : #'initialize-release' }
SWClient >> close [
	(socket isNotNil and: [ socket isConnected ]) ifTrue: [
		socket close
	].
	socket := nil
]

{ #category : #requesting }
SWClient >> exec: target with: options [
	|inst|
	inst := SWServerInstruction new
		execute;
		target: target;
		options: options;
		yourself.
	^ self socket ensureSendMessage: inst toString.

]

{ #category : #public }
SWClient >> get: target [
	|inst|
	inst := SWServerInstruction new
		get;
		target: target;
		yourself.
	^ self socket ensureSendMessage: inst toString
]

{ #category : #requesting }
SWClient >> head: target [
	|req|
	req := SWServerInstruction new
		head;
		target: target;
		yourself.
	^ self socket ensureSendMessage: req toString.

]

{ #category : #requesting }
SWClient >> post: target with: anAssociationArray [
	self socket sendRequestPost: target with: anAssociationArray.
	^ self socket readResponse.

]

{ #category : #requesting }
SWClient >> put: target contents: contents [
	|req|
	req := SWServerInstruction new
		put;
		target: target;
		length: contents size;
		yourself.
	^ self socket
		ensureSendMessage: req toString;
		ensureSendMessage: contents.

]

{ #category : #accessing }
SWClient >> server [

	^ server ifNil: [ server := 'ws://localhost:50000' ]
]

{ #category : #accessing }
SWClient >> server: anObject [

	server := anObject
]

{ #category : #accessing }
SWClient >> socket [
	(socket isNil or: [ socket isConnected not ]) ifTrue: [
		socket := ZnWebSocket to: self server
	].
	^ socket


]

{ #category : #accessing }
SWClient >> socket: anObject [

	socket := anObject
]
