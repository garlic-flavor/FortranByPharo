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

{ #category : #'as yet unclassified' }
SWClient >> ensureSendMessage: aString [
	|res status message|
	res := self socket
		sendMessage: aString;
		readMessage.
	status := SWServerStatus fromSton: (STON reader on: res readStream).
	message := status message.
	self assert: [ status isGood ].
	^ status
]

{ #category : #requesting }
SWClient >> exec: target with: options [
	|inst|
	inst := SWServerInstruction new
		execute;
		target: target;
		options: options;
		yourself.
	^ self ensureSendMessage: inst toString.

]

{ #category : #public }
SWClient >> get: target [
	|inst|
	inst := SWServerInstruction new
		get;
		target: target;
		yourself.
	^ self ensureSendMessage: inst toString
]

{ #category : #requesting }
SWClient >> head: target [
	|req|
	req := SWServerInstruction new
		head;
		target: target;
		yourself.
	^ self ensureSendMessage: req toString.

]

{ #category : #requesting }
SWClient >> put: target contents: contents [
	|req|
	req := SWServerInstruction new
		put;
		target: target;
		length: contents size;
		yourself.
	^ self
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
