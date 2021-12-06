Class {
	#name : #SWTestServer,
	#superclass : #Object,
	#category : #'SWFortranByPharo-Client-Tests'
}

{ #category : #accessing }
SWTestServer >> start [

	| tmp2 |
	ZnServer startDefaultOn: 50000.
	tmp2 := ZnServer default delegate.
	tmp2
		map: 'manage' to: [ :arg1 | 
			| tmp3 |
			(arg1 method = #HEAD or: [ arg1 method = #PUT ])
				ifTrue: [ 
					tmp3 := ZnResponse ok: (ZnEntity text: '').
					tmp3 headers at: #'Last-Modified' put: 'last modified time'.
					tmp3 ]
				ifFalse: [ 
					[ 
					ZnResponse ok: (ZnEntity text:
									 (String streamContents: [ :arg2 | arg1 writeOn: arg2 ])) ]
						on: ConnectionClosed
						do: [  ] ] ];
		map: 'execute' to: (SWWebSocketDelegate
				 map: 'execute'
				 to: [ :arg3 | arg3 sendMessage: arg3 uri asString ])
]

{ #category : #accessing }
SWTestServer >> stop [

	ZnServer default stop
]
