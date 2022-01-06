Class {
	#name : #SWTestServer,
	#superclass : #Object,
	#category : #'SWFortranByPharo-ClientServer-Tests'
}

{ #category : #accessing }
SWTestServer >> start [

	ZnServer startDefaultOn: 50000.
	(ZnServer default delegate)
		map: 'manage' to: [ :request |
			(#(PUT HEAD) anySatisfy: [:one | one = request method ]) ifTrue: [|res|
				res := (ZnResponse ok: (ZnEntity text: '')).
				res headers at: #'Last-Modified' put: 'last modified time'.
				res
			] ifFalse: [ 
				[ 
					ZnResponse ok: (ZnEntity text:(String streamContents: [ :s | request writeOn: s ]))
				] on: ConnectionClosed do: [ ZnResponse serverError: 'Something go wrong.' ]
			].
		];
		map: 'execute' to: (SWWebSocketDelegate
				 map: 'execute'
				 to: [ :ws | ws sendMessage: '{ "code": "ok", "message": "', ws uri asString, '"}' ])
]

{ #category : #accessing }
SWTestServer >> stop [

	ZnServer default stop
]
