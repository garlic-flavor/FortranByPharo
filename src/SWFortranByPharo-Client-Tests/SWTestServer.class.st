Class {
	#name : #SWTestServer,
	#superclass : #Object,
	#category : #'SWFortranByPharo-Client-Tests'
}

{ #category : #accessing }
SWTestServer >> start [
	ZnServer startDefaultOn: 50000.
	ZnServer default delegate
		map: 'manage' to: [ :request |
			request method = #HEAD ifTrue: [
				(ZnResponse statusLine: ZnStatusLine ok)
					headers: (ZnHeaders defaultResponseHeaders
						at: #'Requested-Url' put: request uri;
						yourself);
					yourself
			] ifFalse: [
				[
					ZnResponse ok: (ZnEntity text: (String streamContents: [:s | request writeOn: s]))
				] on: ConnectionClosed do: [ ]
			]
		];
		map: 'execute' to: (SWWebSocketDelegate map: 'execute' to: [:webSocket |
			webSocket sendMessage: webSocket uri asString.
		])
]

{ #category : #accessing }
SWTestServer >> stop [
	ZnServer default stop.
]
