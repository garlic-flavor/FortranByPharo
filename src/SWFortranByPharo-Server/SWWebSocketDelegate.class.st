"
I add a functionality of accessing to request line.
"
Class {
	#name : #SWWebSocketDelegate,
	#superclass : #ZnWebSocketDelegate,
	#category : #'SWFortranByPharo-Server-Wrapper'
}

{ #category : #public }
SWWebSocketDelegate >> handleRequest: request [
	"Server delegate entry point"
	(prefix isNil or: [ prefix = request uri pathSegments ])
		ifFalse: [ ^ ZnResponse notFound: request uri ].
	^ (self isValidWebSocketRequest: request)
			ifTrue: [ self webSocketResponseForRequest: request ]
			ifFalse: [ ZnResponse badRequest: request ]
]

{ #category : #protocol }
SWWebSocketDelegate >> webSocketResponseForRequest: request [
	"Given a valid WebSocket setup request, return the matching server response"
	
	| acceptKey |
	acceptKey := ZnWebSocketUtils handshake: (request headers at: 'Sec-WebSocket-Key').
	^ SWWebSocketResponse new
		uri: request uri;
		statusLine: (ZnStatusLine code: 101);
		headers: (self responseHeadersForKey: acceptKey);
		continuation: self continuation;
		yourself
		
]
