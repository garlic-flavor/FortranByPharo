"
I connect to SWFortranByPharo-Server, then send the requesting database.
"
Class {
	#name : #SWClientOfProjectBuilder,
	#superclass : #Object,
	#instVars : [
		'database',
		'server',
		'socket'
	],
	#category : #'SWFortranByPharo-Client-Client'
}

{ #category : #building }
SWClientOfProjectBuilder class >> build: requestdb [
	self flag: #TODO.
	^ (self new)
		server: 'ws://localhost:8800';
		database: requestdb;
		build
]

{ #category : #'as yet unclassified' }
SWClientOfProjectBuilder class >> buildMessageOf: target [
	|message stream|
	message := (ZnRequest put: target basename)
		entry: (ZnEntity readBinaryFrom: target binaryReadStream
			usingType: ZnMimeType applicationOctetStream andLength: target size).
	stream := ByteArray new writeStream.
	[ message writeOn: stream ] ensure: [ stream close ].
	^ stream contents
	
]

{ #category : #tests }
SWClientOfProjectBuilder class >> test [
	<script>
	|webSocket message stream filepath filecont|
	filepath := FileLocator imageDirectory / 'requestdb' / 'helloworld-ac37f359-9481-0d00-832c-e6fe07c5ba27.db'.
	filecont := filepath binaryReadStream contents.
	message := (ZnRequest put: 'helloworld-ac37f359-9481-0d00-832c-e6fe07c5ba27.db')
		entity: (ZnEntity bytes: filecont).
	stream := ByteArray new writeStream.
	message writeOn: stream.
	webSocket := ZnWebSocket to: 'ws://localhost:8800'.
	[
		webSocket
			sendMessage: stream contents.
	] ensure: [
		webSocket close
	]
]

{ #category : #building }
SWClientOfProjectBuilder >> build [
	self socket sendBytes: (self class buildMessageOf: self database).

]

{ #category : #accessing }
SWClientOfProjectBuilder >> database [

	^ database
]

{ #category : #accessing }
SWClientOfProjectBuilder >> database: anObject [

	database := anObject
]

{ #category : #accessing }
SWClientOfProjectBuilder >> server [

	^ server
]

{ #category : #accessing }
SWClientOfProjectBuilder >> server: anObject [

	server := anObject
]

{ #category : #accessing }
SWClientOfProjectBuilder >> socket [

	^ socket ifNil: [ socket := ZnWebSocket to: self server ]
]

{ #category : #accessing }
SWClientOfProjectBuilder >> socket: anObject [

	socket := anObject
]

{ #category : #building }
SWClientOfProjectBuilder >> waitBuildingResult [
	self flag: #TODO.
]
