"
This is a WebSocket server.
"
Class {
	#name : #SWServer,
	#superclass : #Object,
	#instVars : [
		'status'
	],
	#category : #'SWFortranByPharo-Server-Server'
}

{ #category : #accessing }
SWServer class >> start [
	<script>
	self new
		startOn: 8800.
]

{ #category : #accessing }
SWServer class >> stop [
	<script>
	ZnServer default stop.
]

{ #category : #dispatching }
SWServer >> dispatch: message on: socket [
	|stream request msg selector|
	stream := message asByteArray readStream.
	request := ZnRequestLine readFrom: stream.
	msg := ZnMessage readFrom: stream.
	
	selector := request method asString asLowercase asSymbol, ':with:on:'.
	self perform: selector with: request uri with: msg with: socket.

]

{ #category : #'as yet unclassified' }
SWServer >> get: target with: msg on: socket [
	self flag: #TODO.
	self error: 'no implementation!'
]

{ #category : #initialization }
SWServer >> initialize [
	super initialize.
	status := #waiting.
]

{ #category : #'as yet unclassified' }
SWServer >> put: target with: msg on: socket [
	|filepath writer|
	filepath := FileLocator imageDirectory / ('receiveddb', target asString).
	
	writer := filepath binaryWriteStream.
	[msg entity writeOn: writer.] ensure: [ writer close ]

]

{ #category : #public }
SWServer >> startOn: portNumber [
	ZnServer startDefaultOn: portNumber.
	ZnServer default delegate: (ZnWebSocketDelegate handler: [ :webSocket |
		[
			webSocket runWith: [ :message | self dispatch: message on: webSocket ]
		] on: ConnectionClosed do: [
			Transcript << 'Ignoring connection close, done.'; cr.
		]
	]). 
]
