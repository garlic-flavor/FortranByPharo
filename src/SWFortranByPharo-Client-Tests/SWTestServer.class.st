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
			(request method = #HEAD or: [ request method = #PUT ]) ifTrue: [|res|
				res := ZnResponse ok: (ZnEntity text: '').
				res headers at: #'Last-Modified' put: 'last modified time'.
				res
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
