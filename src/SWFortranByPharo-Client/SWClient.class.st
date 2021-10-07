"
I am a WebSocket client
"
Class {
	#name : #SWClient,
	#superclass : #Object,
	#instVars : [
		'host',
		'port'
	],
	#category : #'SWFortranByPharo-Client-Client'
}

{ #category : #requesting }
SWClient >> exec: target with: options [
	"I run a shell command on the server.
	and, return a WebSocket to contacet to the server."
	|url socket status|
	url := ZnUrl new
		scheme: 'ws';
		host: self host;
		port: self port;
		addPathSegment: 'execute';
		queryAt: #target put: target;
		yourself.
	options do: [ :each | url queryAt: #args add: each ].
	socket := ZnWebSocket to: url.
	status := SWServerStatus readFrom: socket.
	status isOk ifFalse: [
		socket close.
		status inspect.
		self error: 'The execution failed.'
	].
	^ status
]

{ #category : #public }
SWClient >> get: target [
	"I am a GET of HTTP."
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
	"I am a HEAD of HTTP."
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
	"I am a PUT of HTTP."
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
