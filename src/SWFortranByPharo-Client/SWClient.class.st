"
I am a WebSocket client
"
Class {
	#name : #SWClient,
	#superclass : #Object,
	#instVars : [
		'socket',
		'host',
		'port'
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
	|url|
	url := ZnUrl new
		scheme: 'ws';
		host: self host;
		port: self port;
		addPathSegment: 'execute';
		queryAt: #target put: target;
		yourself.
	options do: [ :each | url queryAt: #args add: each ].
	^ ZnWebSocket to: url
]

{ #category : #public }
SWClient >> get: target [
	^ (ZnClient new
		http;
		host: self host;
		port: self port;
		addPathSegment: 'manage';
		enforceHttpSuccess: true;
		queryAt: #target put: target;
		get;
		entity) contents.

]

{ #category : #requesting }
SWClient >> head: target [
	|res|
	res := ZnClient new
		http;
		host: self host;
		port: self port;
		addPathSegment: 'manage';
		queryAt: #target put: target;
		head;
		response.
	^ res isError ifTrue: [
		nil
	] ifFalse: [
		res headers at: #'Last-Modified' ifAbsent: [ '' ]
	]
]

{ #category : #accessing }
SWClient >> host [

	^ host ifNil: [ host := 'localhost' ]
]

{ #category : #accessing }
SWClient >> host: anObject [

	host := anObject
]

{ #category : #accessing }
SWClient >> port [

	^ port ifNil: [ port := 50000 ]
]

{ #category : #accessing }
SWClient >> port: anObject [

	port := anObject
]

{ #category : #requesting }
SWClient >> put: target contents: contents [
	^ (ZnClient new
		http;
		host: self host;
		port: self port;
		addPathSegment: 'manage';
		queryAt: #target put: target;
		contents: contents;
		enforceHttpSuccess: true;
		put;
		response) headers at: #'Last-Modified'
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
