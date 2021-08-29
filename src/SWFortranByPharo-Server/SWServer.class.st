"
This is a WebSocket server.
"
Class {
	#name : #SWServer,
	#superclass : #SWStd,
	#instVars : [
		'env'
	],
	#classVars : [
		'default'
	],
	#category : #'SWFortranByPharo-Server-Server'
}

{ #category : #'code generation' }
SWServer class >> _rb_startOn_using: transpiler [
	transpiler putCode: '\
		EM.run{
			EM::WebSocket.run(:host => "0.0.0.0", :port=>portNumber) do |ws|
				ws.onmessage {  |msg|
					self.dispatch_on_(msg, ws)
				}
			end
		}' with: {}.

]

{ #category : #accessing }
SWServer class >> default [
	^ default
]

{ #category : #converting }
SWServer class >> filePathOf: aName [
	|path|
	path := FileLocator imageDirectory / (aName asString trimLeft: [ :c | c = $/ ]).
	(FileLocator imageDirectory contains: path) ifFalse: [
		path := FileLocator imageDirectory
	].
	path parent ensureCreateDirectory.
	^ path

]

{ #category : #testing }
SWServer class >> isRunning [
	^ ZnServer default isRunning
]

{ #category : #'code generation' }
SWServer class >> rb_requirements [
	^ {
		SWStd.
		SWSession.
		SWServerInstruction.
		SWServerStatus.
		'ZnServer.rb'.
	}
]

{ #category : #accessing }
SWServer class >> start [
	<script>
	default := self new
		startOn: 50000.
]

{ #category : #accessing }
SWServer class >> stop [
	<script>
	ZnServer default stop.
]

{ #category : #testing }
SWServer class >> testRunning [
	<sampleInstance>
	^ ZnServer default isRunning ifTrue: [ 'The server is running' ] ifFalse: [ 'The server is not running' ]
]

{ #category : #'code generation' }
SWServer class >> transpile [
	<script>
	|instance contents|
	instance := self new.
	contents := SWTranspilerOfRuby new 
		classes: { SWStd. SWServerInstruction. SWServerStatus. SWSession. self };
		transpile;
		contents.
	contents inspect.

]

{ #category : #dispatching }
SWServer >> dispatch: message on: session [
	session instruction isHead ifTrue: [
		^ self headOn: session
	].
	session instruction isGet ifTrue: [
		^ self get: session
	].
	session instruction isPut ifTrue: [
		message ifNotNil: [
			^ self put: message on: session
		] ifNil: [
			^ self
		]
	].
	session instruction isExecute ifTrue: [
		^ self exec: session
	].

	self error: 'no implementation'

"
	|obj method target|
	obj := self parseRequest: message.
	method := obj at: #method ifAbsent: ''.
	target := self filePathOf: (obj at: #target ifAbsent: '').
	method = #GET ifTrue: [
		^ self get: target with: obj on: socket
	].
	method = #PUT ifTrue: [
	].
	method = #POST ifTrue: [
		^ self post: target with: obj on: socket
	].
"
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
SWServer >> exec: session [
	|exe result|
	exe := session instruction target fullName.
	result := SWShell execute: exe arguments: session instruction options.
	session status ok.
	session status message: result

]

{ #category : #responses }
SWServer >> get: session [
	session instruction target = FileLocator imageDirectory ifTrue: [
		#(script src obj exe) do: [ :each |
			session status entity
				at: each put: (SWShell lsr: FileLocator imageDirectory / each)
		].
		^ session status ok.
	].
	(session instruction target isFile) ifTrue: [
		session status message: session instruction target readStream contents.
		^ session status ok.
	].

	^ session status failed; message: 'not implemented yet'

]

{ #category : #responses }
SWServer >> get: target with: msg on: socket [
	target = FileLocator imageDirectory ifTrue: [
		^ socket sendResponseOk: {
			'entity' -> (#('src' 'obj' 'exe') collect: [ :each |
				SWShell lsr: FileLocator imageDirectory / each
			])
		}
	].
	
	self flag: #TODO.
	socket sendResponseNotImplemented: { 'target' -> target rel fullName }.
]

{ #category : #responses }
SWServer >> headOn: session [
	session instruction target exists ifTrue: [
		(#(exists accessTime changeTime creationTime) do: [ :each |
			session status entity at: each asString put: (session instruction target perform: each) asString
		]).
	] ifFalse: [
		session status entity at: 'exists' put: false
	]

]

{ #category : #initialization }
SWServer >> initialize [
	super initialize.

]

{ #category : #grammar }
SWServer >> main: argv [
	self startOn: 50000.
]

{ #category : #executing }
SWServer >> make: target by: method with: msg on: socket [
	|type|
	type := (msg at: #type ifAbsent: ['']).
	(type beginsWith: 'f') ifTrue: [
		|sources result|
		sources := (msg at: #sources ifAbsent: [{}]) collect: [ :each | self class filePathOf: each ].
		result := self env fortranCompilerAdapterClass perform: method with: sources with: target.
		socket sendResponseOk: {
			'status' -> 'succeeded'.
			'stdout' -> result.
			'Location' -> target rel fullName.
		}
	].
	self error: 'no implementation'

]

{ #category : #parsing }
SWServer >> parseRequest: received [
	|request dict|
	request := ZnRequest readFrom: received readStream.
	dict := Dictionary new
		at: #method put: request method;
		at: #target put: request uri;
		at: #type put: request contentType;
		at: #original put: request;
		yourself.
	request headersDo: [ :key :value | dict at: key put: value ].
	request contentType = ZnMimeType applicationJson ifTrue: [
		(STON reader on: request entity contents readStream; next) associationsDo: [ :assoc |
			dict at: assoc key put: assoc value
		]
	] ifFalse: [
		dict at: #entity put: (request entity ifNotNil: [ request entity contents ])
	].
	^ dict
]

{ #category : #responses }
SWServer >> post: target with: msg on: socket [
	|action|
	action := msg at: #action ifAbsent: [''].
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

{ #category : #responses }
SWServer >> put: message on: session [
	session instruction target writeStreamDo: [ :writer |
		writer
			position: session status completed;
			truncate;
			<< message
	].
	session status complete: message size

]

{ #category : #public }
SWServer >> startOn: portNumber [
	ZnServer startDefaultOn: portNumber.
	ZnServer default delegate: (ZnWebSocketDelegate handler: [ :webSocket |
		[|session|
			session := SWSession new
				socket: webSocket;
				yourself.
			webSocket runWith: [ :message |
				[
					session status isGood ifTrue: [
						session instruction ifNotNil: [
							self dispatch: message on: session
						] ifNil: [
							session instruction: (SWServerInstruction fromSton: (STON reader on: message readStream)).
							session instruction target: (self class filePathOf: session instruction target).
							session status: (SWServerStatus new
								toComplete: session instruction length;
								yourself).
							self dispatch: nil on: session.
						].
						session status isOk ifTrue: [ 
							session instruction: nil
						]
					]
				] on: Error do: [:exception |
					session status failed; message: exception description; request: message
				].
				webSocket sendMessage: session status toString
			]
		] on: ConnectionClosed do: [:err|
			Transcript << err asString; cr.
		]
	]). 
]
