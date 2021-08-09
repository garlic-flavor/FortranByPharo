Extension { #name : #ZnWebSocket }

{ #category : #'*SWFortranByPharo-Client' }
ZnWebSocket >> ensureSendMessage: aString [
	|res status|
	res := self
		sendMessage: aString;
		readMessage.
	status := SWServerStatus fromSton: (STON reader on: res readStream).
	self assert: [ status isGood ].
	^ status
]
