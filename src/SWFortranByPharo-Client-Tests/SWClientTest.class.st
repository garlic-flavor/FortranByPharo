"
A SWClientTest is a test class for testing the behavior of SWClient
"
Class {
	#name : #SWClientTest,
	#superclass : #TestCase,
	#instVars : [
		'client'
	],
	#category : #'SWFortranByPharo-Client-Tests-Client'
}

{ #category : #running }
SWClientTest >> setUp [
	super setUp.
	ZnServer startDefaultOn: 50000.
	ZnServer default delegate: (ZnWebSocketDelegate handler: [ :webSocket |
		[
			webSocket runWith: [ :message ||inst stat|
				Transcript << 'reach'; cr.
				inst := SWServerInstruction fromSton: (STON reader on: message readStream).
				stat := SWServerStatus new.
				stat ok.
				stat toComplete: inst length.
				stat entity
					at: 'request' put: inst toString.
				webSocket sendMessage: stat toString.
			]
		] on: ConnectionClosed do: [ :exception |
			Transcript show: exception asString; cr.
		]
	]).
	client := SWClient new
		server: 'ws://localhost:50000';
		yourself
	"Put here a common initialization logic for tests"
]

{ #category : #running }
SWClientTest >> tearDown [
	ZnServer default isRunning ifTrue: [ ZnServer default stop ].
	super tearDown.
]

{ #category : #tests }
SWClientTest >> testGet [
	|res req|
	res := client get: 'hogehoge.txt'.
	req := SWServerInstruction fromSton: (STON reader on: (res entity at: 'request') readStream).
	self assert: req code equals: 'get'.
	self assert: req target equals: 'hogehoge.txt'.
	
]
