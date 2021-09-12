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
	^ path
"
	path parent ensureCreateDirectory.
	^ path
"
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
		SWShell.
		'ZnServer.rb'.
	}
]

{ #category : #'as yet unclassified' }
SWServer class >> relPathOf: path [
	^ path relativeTo: FileLocator imageDirectory
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
	self flag: #ToRemove.
	exe := session instruction target fullName.
	result := SWShell execute: exe arguments: session instruction options.
	session status ok.
	session status message: result

]

{ #category : #responses }
SWServer >> get: target [
	^ target exists ifTrue: [
		target isDirectory ifTrue: [ |writer|
			writer := XMLWriter new.
			writer tag: #html attributes: { 'lang' -> 'ja' } with: [ :w |
				w
					tag: #head with: [ :w2 |
						w2 tag: #title with: target basename
					];
					tag: #body with: [ :w2 |
						target children do: [ :child |
							child isDirectory ifTrue: [
								w2 tag: #a attributes: { #href -> ('/manage?target=', (self class relPathOf: child) fullName) } with: child basename;
									tag: #br
							] ifFalse: [
								w2
									tag: #span with: child basename;
									tag: #br
							]
						]
					]
			].
			ZnResponse ok: (ZnEntity html: writer contents)
		] ifFalse: [
			ZnResponse noContent
		]
	] ifFalse: [ 
		ZnResponse notFound: (self class relPathOf: target) fullName asZnUrl
	]
"
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
"

]

{ #category : #'accessing structure variables' }
SWServer >> head: target [
	^ target exists ifTrue: [
		(ZnResponse statusLine: ZnStatusLine ok)
			headers: (ZnHeaders defaultResponseHeaders
				at: #'Last-Modified' put: target changeTime asString;
				yourself);
			yourself
	] ifFalse: [
		ZnResponse notFound: (self class relPathOf: target) fullName asZnUrl
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
	self flag: #ToRemove.
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

{ #category : #'as yet unclassified' }
SWServer >> manage: request [
	|target|
	target := self class filePathOf: (request uri queryAt: #target ifAbsent: [ '' ]).
	(request method = #HEAD) ifTrue: [ 
		^ self head: target
	].
	(request method = #GET) ifTrue: [
		^ self get: target
	].
	(request method = #PUT) ifTrue: [
		^ self put: target contents: request entity contents
	].
	^ ZnResponse badRequest: request.
]

{ #category : #requesting }
SWServer >> put: target contents: contents [
	|res|
	target parent ensureCreateDirectory.
	target writeStreamDo: [ :writer |
		writer 
			position: 0;
			truncate;
			<< contents.
	].
	res := ZnResponse ok: (ZnEntity text: '').
	res headers at: #'Last-Modified' put: target changeTime asString.
	^ res
]

{ #category : #public }
SWServer >> startOn: portNumber [
	ZnServer startDefaultOn: portNumber.
	ZnServer default delegate
		map: 'manage'
		to: [ :request | self manage: request ];
		map: 'execute'
		to: (ZnWebSocketDelegate map: 'execute' to: [:webSocket |
			[ 
			] on: ConnectionClosed do: [ :err |
				Transcript << err asString; cr.
			]
		]).
"
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
"
]
