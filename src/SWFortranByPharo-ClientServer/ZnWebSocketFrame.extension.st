Extension { #name : #ZnWebSocketFrame }

{ #category : #'*SWFortranByPharo-ClientServer' }
ZnWebSocketFrame class >> initializeInstanceSideTranspiler: transpiler [
	transpiler
		defineMethodReturnsReceiver: #writeOn: 
]