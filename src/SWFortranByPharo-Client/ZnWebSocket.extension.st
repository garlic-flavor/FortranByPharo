Extension { #name : #ZnWebSocket }

{ #category : #'*SWFortranByPharo-Client' }
ZnWebSocket >> ensureSendMessage: aString [
	|res status message|
	res := self
		sendMessage: aString;
		readMessage.
	status := SWServerStatus fromSton: (STON reader on: res readStream).
	message := status message.
	self assert: [ status isGood ].
	^ status
]
