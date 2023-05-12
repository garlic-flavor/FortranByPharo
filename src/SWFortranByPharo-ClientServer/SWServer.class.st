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
	^ self build: [ :transpiler | ]

]

{ #category : #accessing }
SWServer class >> build: initBlock [
	|transpiler|
	transpiler := SWMTofJS main: self.
	initBlock cull: transpiler.
	transpiler transpile.
	^ transpiler

]

{ #category : #accessing }
SWServer class >> buildThenInspect [
	<script>
	|module|
	module := self build.
	module contents inspect.

]

{ #category : #initialization }
SWServer class >> decode_STONWriter: ct [
	ct
		declareMethodReturnsReceiver: #jsonMode:

]

{ #category : #initialization }
SWServer class >> decode_ZnEntity: ct [
	ct
		declareMethod: #contents asReturn: String

]

{ #category : #initialization }
SWServer class >> decode_ZnEntityClass: ct [
	ct
		declareMethodReturnsReceiversInstance: #type:

]

{ #category : #initialization }
SWServer class >> decode_ZnHeadersClass: ct [
	ct
		declareMethodReturnsReceiversClass: #defaultResponseHeaders

]

{ #category : #initialization }
SWServer class >> decode_ZnManagingMultiThreadedServer: ct [
	ct
		declareMethodReturnsReceiver: #closeConnections

]

{ #category : #initialization }
SWServer class >> decode_ZnResponseClass: transpiler [
	transpiler
		declareMethodReturnsReceiversInstance: #notFound:
]

{ #category : #initialization }
SWServer class >> decode_ZnServer: ct [
	ct
		declareMethodReturnsSecondArgument: #optionAt:ifAbsent:
]

{ #category : #initialization }
SWServer class >> decode_ZnSingleThreadedServer: ct [
	ct
		declareMethodReturnsReceiver: #stop:;
		declareMethodReturnsReceiver: #start

]

{ #category : #initialization }
SWServer class >> decode_ZnWebSocket: ct [
	ct
		declareMethodReturnsReceiver: #sendMessage:

]

{ #category : #accessing }
SWServer class >> default [
	^ default
]

{ #category : #converting }
SWServer class >> filePathOf: aName [
	|path|
self error; flag: #toRemove.
	path := SWOS default localDirectory joinPath: (aName asString trimLeft: [ :c | c = $/ ]).
	(SWOS default localDirectory contains: path) ifFalse: [
		self error: aName, ' is in out of the local directory.'
	].
	^ path

]

{ #category : #testing }
SWServer class >> isRunning [
	^ ZnServer default isRunning
]

{ #category : #api }
SWServer class >> main [
	SWStd_OLD
		import: #(PharoObject Transcript Exception) from: 'Pharo';
		import: #(ZnServer ZnWebSocketDelegate SWWebSocketDelegate ZnResponse ZnEntity ZnStatusLine ZnHeaders) from: 'ZnServer'.

	self new startOn: 50000
]

{ #category : #accessing }
SWServer class >> put [
	<script>
	|module runner|
	self start.
	module := self build: [ :mt |

	].
	runner := SWPRofJS new.
	runner put: module.
	self stop.
	module contents inspect

]

{ #category : #'as yet unclassified' }
SWServer class >> putQueryAtIfAbsent: mbt [
	mbt isExpression ifTrue: [
		self putQueryAtIfAbsentAsExpression: mbt
	] ifFalse: [
		self putQueryAtIfAbsentAsNotExpression: mbt
	]

]

{ #category : #'as yet unclassified' }
SWServer class >> putQueryAtIfAbsentAsExpression: mbt [
	|rVal|
	rVal := (mbt makeNewVariable: mbt expression result) node name.
	mbt preserveCurrentStatement: [
		mbt put: rVal; put: ' = '; transpileChild: mbt children first;
			put: '.queryAt('; transpileChild: mbt children second;  put: ')'; putStatementDelimiter; cr;
			put: 'if('; put: rVal; put: ' == null)'; putBlock: mbt children third assignTo: rVal;
			preventStatementDelimiter
	].
	mbt put: rVal

]

{ #category : #'as yet unclassified' }
SWServer class >> putQueryAtIfAbsentAsNotExpression: mbt [
	|rVal|
	self halt.
	rVal := mbt makeNewVariable: mbt expression result.
	mbt put: rVal node name; put: ' = '; transpileChild: mbt children first;
		put: '.queryAt('; transpileChild: mbt children second;  put: ')'; putStatementDelimiter; cr;
		put: 'if('; put: rVal node name; put: ' != null)'; putPresentBlock: mbt children third with: rVal node name;
		preventStatementDelimiter

]

{ #category : #'as yet unclassified' }
SWServer class >> putQueryAtIfPresent: mbt [
	|rVal|
	mbt isExpression ifTrue: [ self error ].
	rVal := mbt makeNewVariable: mbt expression result.
	mbt put: rVal node name; put: ' = '; transpileChild: mbt children first;
		put: '.queryAt('; transpileChild: mbt children second;  put: ')'; putStatementDelimiter; cr;
		put: 'if('; put: rVal node name; put: ' != null)'; putPresentBlock: mbt children third with: rVal node name;
		preventStatementDelimiter

]

{ #category : #'as yet unclassified' }
SWServer class >> relPathOf: path [
	^ path relativeTo: SWOS default localDirectory
]

{ #category : #initialization }
SWServer class >> setupTranspiler: mt [
	(mt global getClassInfo: ZnRequest)
		declareMethod: #uri asReturn: ZnUrl.
	(mt global getClassInfo: ZnUrl)
		declareMethodReturnsSecondArgumentsElement: #queryAt:ifPresent:.
	
	(mt pool getClassInfo: ZnUrl)
		senderTranspilerOf: #queryAt:ifPresent: is: [ :mbt | self putQueryAtIfPresent: mbt ];
		senderTranspilerOf: #queryAt:ifAbsent: is: [ :mbt | self putQueryAtIfAbsent: mbt ];
		senderTranspilerOf: #queryAt: is: [ :mbt | mbt putMessageWithSelector: #queryAt ].

	(mt pool getClassInfo: ZnHeaders)
		senderTranspilerOf: #at:put: is: [ :mbt | mbt putAtPut  ].

	SWShell setupTranspiler: mt.
	SWServerStatus setupTranspiler: mt.
	SWWebSocket setupTranspiler: mt.

]

{ #category : #'as yet unclassified' }
SWServer class >> solveDependencies: transpiler [
	SWShell solveDependencies: transpiler.
	SWServerStatus solveDependencies: transpiler.
	transpiler
		transpile: SWShell;
		transpile: SWServerStatus
]

{ #category : #accessing }
SWServer class >> start [
	<script>
	^ default := self new
		startOn: 50000.
]

{ #category : #accessing }
SWServer class >> stop [
	<sampleInstance>
	ZnServer default stop.
	^ self testRunning.
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

	^ env ifNil: [ env := SWOS default ]
]

{ #category : #accessing }
SWServer >> env: anObject [

	env := anObject
]

{ #category : #execution }
SWServer >> execute: webSocket [
	[ |target args result|
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
	|action type|
	action := opts at: 'action'.
	type := opts at: 'type'.
	action = #go ifTrue: [
		type = #f90 ifTrue: [
			^ self goF90: target options: opts
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
