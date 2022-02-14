"
I am a HTTP / WebSocket server.
"
Class {
	#name : #SWServer,
	#superclass : #Object,
	#instVars : [
		'env'
	],
	#classInstVars : [
		'default'
	],
	#category : #'SWFortranByPharo-ClientServer-Server'
}

{ #category : #accessing }
SWServer class >> build [
	^ self moduleTranspiler
		transpile;
		yourself

]

{ #category : #accessing }
SWServer class >> buildThenInspect [
	<script>
	|module|
	module := self moduleTranspiler.
	module logger enabled: true.
	module transpile.
	module contents inspect.

]

{ #category : #accessing }
SWServer class >> default [
	^ default
]

{ #category : #converting }
SWServer class >> filePathOf: aName [
	|path|
self error; flag: #toRemove.
	path := SWShellEnvironment default localDirectory joinPath: (aName asString trimLeft: [ :c | c = $/ ]).
	(SWShellEnvironment default localDirectory contains: path) ifFalse: [
		self error: aName, ' is in out of the local directory.'
	].
	^ path

]

{ #category : #initialization }
SWServer class >> initialize_STONWriter: ct [
	ct
		declareMethodReturnsReceiver: #jsonMode:

]

{ #category : #initialization }
SWServer class >> initialize_ZnEntity: ct [
	ct
		declareMethod: #contents asReturn: String

]

{ #category : #initialization }
SWServer class >> initialize_ZnEntityClass: ct [
	ct
		declareMethodReturnsReceiversInstance: #type:

]

{ #category : #initialization }
SWServer class >> initialize_ZnHeadersClass: ct [
	ct
		declareMethodReturnsReceiversClass: #defaultResponseHeaders

]

{ #category : #initialization }
SWServer class >> initialize_ZnManagingMultiThreadedServer: ct [
	ct
		declareMethodReturnsReceiver: #closeConnections

]

{ #category : #initialization }
SWServer class >> initialize_ZnResponseClass: transpiler [
	transpiler
		declareMethodReturnsReceiversInstance: #notFound:
]

{ #category : #initialization }
SWServer class >> initialize_ZnServer: ct [
	ct
		declareMethodReturnsSecondArgument: #optionAt:ifAbsent:
]

{ #category : #initialization }
SWServer class >> initialize_ZnSingleThreadedServer: ct [
	ct
		declareMethodReturnsReceiver: #stop:;
		declareMethodReturnsReceiver: #start

]

{ #category : #initialization }
SWServer class >> initialize_ZnWebSocket: ct [
	ct
		declareMethodReturnsReceiver: #sendMessage:

]

{ #category : #testing }
SWServer class >> isRunning [
	^ ZnServer default isRunning
]

{ #category : #api }
SWServer class >> main [
	SWStd
		import: #(PharoObject Transcript Exception) from: 'Pharo';
		import: #(ZnServer ZnWebSocketDelegate SWWebSocketDelegate ZnResponse ZnEntity ZnStatusLine ZnHeaders) from: 'ZnServer'.

	self new startOn: 50000
]

{ #category : #accessing }
SWServer class >> moduleTranspiler [
	^ SWMTofJS newFrom: self.

]

{ #category : #accessing }
SWServer class >> put [
	<script>
	|module runner|
	self start.
	module := self build.
	runner := SWPRofJS new.
	runner put: module.
	self stop.
	module contents inspect

]

{ #category : #'as yet unclassified' }
SWServer class >> relPathOf: path [
	^ path relativeTo: SWShellEnvironment default localDirectory
]

{ #category : #'as yet unclassified' }
SWServer class >> solveDependenciesUsing: transpiler [
	transpiler
		transpile: SWShell;
		transpile: SWShellEnvironment;
		transpile: SWServerStatus
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

{ #category : #adding }
SWServer >> addFileHeaderInfoOf: file to: headers [
	headers
		at: 'Content-Location' put: (file relativeTo: self env localDirectory) fullName;
		at: 'Last-Modified' put: file changeTime asString.

]

{ #category : #accessing }
SWServer >> env [

	^ env ifNil: [ env := SWShellEnvironment default ]
]

{ #category : #accessing }
SWServer >> env: anObject [

	env := anObject
]

{ #category : #execution }
SWServer >> execute: webSocket [
	|target args result|
	[ 
		target := webSocket uri queryAt: #target.
		args := webSocket uri queryAt: #args ifAbsent: [ '' ].
		args isArray ifFalse: [ args := { args } ].
		result := SWShell execute: target arguments: args.
		webSocket sendMessage: (SWServerStatus ok
			message: result;
			uri: webSocket uri asString;
			yourself) toString
	] on: Exception do: [ :exception |
		webSocket sendMessage: (
			SWServerStatus new
				failed;
				message: exception asString;
				uri: webSocket uri asString;
				yourself) toString
	]
]

{ #category : #responses }
SWServer >> get: target [
	self error; flag: #toRewrite.
"
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

{ #category : #'as yet unclassified' }
SWServer >> goF90: target options: opts [
	|adapter stdout|
	adapter := self env fortranCompilerAdapterClass  new
		basename: target;
		yourself.
	adapter compile.
	stdout := adapter run.
	^ ZnResponse ok: (ZnEntity text: stdout).
	
]

{ #category : #'accessing structure variables' }
SWServer >> head: target [
	|file|
self error; flag: #toRewrite.
	file := SWShell filePathOf: target.
	^ file exists ifTrue: [
		(ZnResponse statusLine: ZnStatusLine ok)
			headers: (ZnHeaders defaultResponseHeaders
				at: 'Content-Location' put: (file relativeTo: self env localDirectory) fullName;
				at: 'Last-Modified' put: file changeTime asString;
				yourself);
			yourself
	] ifFalse: [
		ZnResponse notFound: target asZnUrl
	]
]

{ #category : #'as yet unclassified' }
SWServer >> manage: request [
	[ |target|
		target := (request uri queryAt: #target ifAbsent: [ '' ]) trimLeft: [ :c | c = $/ ].
		request method = #HEAD ifTrue: [ 
			^ self head: target
		].
		request method = #GET ifTrue: [
			^ self get: target
		].
		request method = #PUT ifTrue:  [
			request uri queryAt: #type ifPresent: [ :type |
				^ self put: target type: type contents: request entity contents
			].
			^ self put: target contents: request entity contents
		].
		request method = #POST ifTrue: [
			^ self post: target options: (STONJSON fromString: request entity contents).
		].
		^ ZnResponse badRequest: request
	] on: Exception do: [ :e |
		^ ZnResponse serverErrorWithEntity: (ZnEntity text: e asString)
	]
]

{ #category : #'as yet unclassified' }
SWServer >> post: target options: opts [
	opts at: #action ifPresent: [ :action |
		action = #go ifTrue: [
			opts at: #type ifPresent: [ :type |
				type = #f90 ifTrue: [
					^ self goF90: target options: opts
				]
			]
		]
	].
	self error: 'no implementation.'
]

{ #category : #requesting }
SWServer >> put: target contents: contents [
	|res file|
	file := SWShell put: target contents: contents.
	res := ZnResponse ok: (ZnEntity text: '').
	self addFileHeaderInfoOf: file to: res headers.
	^ res

]

{ #category : #requesting }
SWServer >> put: target type: type contents: contents [
	type = 'f90' ifTrue: [
		^ self putF90: target contents: contents
	].
	self error: 'no implementation'
]

{ #category : #'as yet unclassified' }
SWServer >> putF90: target contents: contents [
	|adapter file res|
	adapter := self env fortranCompilerAdapterClass new
		basename: target;
		contents: contents;
		yourself.
	file := adapter put.
	res := ZnResponse ok: (ZnEntity text: '').
	self addFileHeaderInfoOf: file to: res headers.
	^ res

]

{ #category : #public }
SWServer >> startOn: portNumber [
	ZnServer startDefaultOn: portNumber.
	ZnServer default delegate
		map: 'manage'
		to: [ :request |
			SWType declare: #request as: ZnRequest.
			self manage: request
		];
		map: 'execute'
		to: (SWWebSocketDelegate handler: [:webSocket |
			SWType declare: #webSocket as: SWWebSocket.
			[
				self execute: webSocket
			] on: ConnectionClosed do: [ :err |
				Transcript << err asString; cr.
			]
		]).
]
