"
This is a WebSocket server.
"
Class {
	#name : #SWServer,
	#superclass : #SWSource,
	#instVars : [
		'env'
	],
	#category : #'SWFortranByPharo-Server-Server'
}

{ #category : #testing }
SWServer class >> isRunning [
	<sampleInstance>
	^ ZnServer default isRunning ifTrue: [ 'The server is running' ] ifFalse: [ 'The server is not running' ]
]

{ #category : #accessing }
SWServer class >> start [
	<script>
	self new
		startOn: 50000.
]

{ #category : #accessing }
SWServer class >> stop [
	<script>
	ZnServer default stop.
]

{ #category : #tests }
SWServer class >> transpile [
	<script>
	|instance contents|
	instance := self new.
	contents := SWTranspilerOfRuby new 
		source: instance;
		transpile;
		contents.
	contents inspect.

]

{ #category : #dispatching }
SWServer >> dispatch: message on: socket [
	|obj method target|
	obj := socket parseRequest: message.
	method := obj at: #method ifAbsent: ''.
	target := self filePathOf: (obj at: #target ifAbsent: '').
	method = #GET ifTrue: [
		^ self get: target with: obj on: socket
	].
	method = #HEAD ifTrue: [ 
		^ self head: target with: obj on: socket
	].
	method = #PUT ifTrue: [
		^ self put: target with: obj on: socket
	].
	method = #POST ifTrue: [
		^ self post: target with: obj on: socket
	].
	^ socket sendResponseBadRequest: message.

]

{ #category : #accessing }
SWServer >> env [

	^ env ifNil: [ env := SWShellEnvironment newDefault ]
]

{ #category : #accessing }
SWServer >> env: anObject [

	env := anObject
]

{ #category : #executing }
SWServer >> exec: target with: msg on: socket [
	|result|
	
	result := SWShell execute: target fullName arguments: (msg at: #arguments ifAbsent: {}).
	socket sendResponseOk: {
		'status' -> 'ok'.
		'stdout' -> result.
	}

]

{ #category : #'as yet unclassified' }
SWServer >> filePathOf: name [
	|relname result|
	relname := name asString trimLeft: [ :c | c = $/ ].
	result := relname ifNotEmpty: [ FileLocator imageDirectory / relname ] ifEmpty: [ FileLocator imageDirectory ].
	result parent ensureCreateDirectory.
	^ result
]

{ #category : #'code generation - protected' }
SWServer >> functionDeclarations [
	^ #()
]

{ #category : #responses }
SWServer >> get: target with: msg on: socket [
	target = FileLocator imageDirectory ifTrue: [
		^ socket sendResponseOk: {
			'entity' -> (#('src' 'obj' 'exe') collect: [ :each |
				SWShell ls: FileLocator imageDirectory / each
			])
		}
	].
	
	self flag: #TODO.
	socket sendResponseNotImplemented: { 'target' -> target rel fullName }.
]

{ #category : #responses }
SWServer >> head: target with: msg on: socket [
	^ socket sendResponseOk: (#(exists accessTime changeTime creationTime) collect: [ :each |
		(each asString) -> (target perform: each)
	]).

]

{ #category : #initialization }
SWServer >> initialize [
	super initialize.
	self description: 'This is a server.'
]

{ #category : #executing }
SWServer >> make: target by: method with: msg on: socket [
	|type|
	type := (msg at: #type ifAbsent: '').
	(type beginsWith: 'f') ifTrue: [
		|sources result|
		sources := (msg at: #sources ifAbsent: {}) collect: [ :each | self filePathOf: each ].
		result := self env fortranCompilerAdapterClass perform: method with: sources with: target.
		socket sendResponseOk: {
			'status' -> 'succeeded'.
			'stdout' -> result.
			'Location' -> target rel fullName.
		}
	].
	self error: 'no implementation'

]

{ #category : #responses }
SWServer >> post: target with: msg on: socket [
	|action|
	action := msg at: #action ifAbsent: ''.
	action = #compile ifTrue: [
		^ self make: target by: #compileFortranFiles:to: with: msg on: socket.
	].
	action = #link ifTrue: [
		^ self make: target by: #linkObjs:to: with: msg on: socket.
	].
	action = #execute ifTrue: [
		^ self exec: target with: msg on: socket.
	].
	action = #cat ifTrue: [
		^ socket sendResponseOk: target contents
	].
	socket sendResponseNotImplemented: { 'action' -> action }.

]

{ #category : #grammar }
SWServer >> program [
	self startOn: 50000.
]

{ #category : #responses }
SWServer >> put: target with: msg on: socket [
	target writeStreamDo: [ :writer |
		(msg at: 'Creation-Mode' ifAbsent: '') = 'new' ifTrue: [
			writer truncate.
		].
		(msg at: 'Creation-Mode' ifAbsent: '') = 'append' ifTrue: [
			writer setToEnd.
		].
		writer << (msg at: #entity ifAbsent: '').
	].
	^ socket sendResponseCreated: target rel fullName with: {  }

]

{ #category : #'as yet unclassified' }
SWServer >> rb_fileHeaders [
	^ {
		'require ''em-websocket'''
	}
]

{ #category : #'as yet unclassified' }
SWServer >> rb_startOn_with: arguments using: transpiler [
	|portNumber|
	portNumber := (arguments at: 1) evaluate.
	transpiler putCode: 'EM.run{'.
	transpiler putCode: '}'.

]

{ #category : #public }
SWServer >> startOn: portNumber [
	ZnServer startDefaultOn: portNumber.
	ZnServer default delegate: (ZnWebSocketDelegate handler: [ :webSocket |
		[
			webSocket runWith: [ :message |
				[ self dispatch: message on: webSocket ] on: Error do: [:exception |
					webSocket sendResponseInternalServerError: {
						#required -> message.
						#message -> exception description
					}
				]
			]
		] on: ConnectionClosed do: [
			Transcript << 'Ignoring connection close, done.'; cr.
		]
	]). 
]
