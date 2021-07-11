Class {
	#name : #SWZnWebSocket,
	#superclass : #TestCase,
	#instVars : [
		'client'
	],
	#category : #'SWFortranByPharo-Base-Test'
}

{ #category : #'as yet unclassified' }
SWZnWebSocket >> readRequest [
	^ client parseRequest: client readMessage
]

{ #category : #running }
SWZnWebSocket >> setUp [
	super setUp.
	ZnServer startDefaultOn: 50000.
	ZnServer default delegate: (ZnWebSocketDelegate handler: ZnWebSocketEchoHandler new).
	
	client := ZnWebSocket to: 'ws://localhost:50000'.

	"Put here a common initialization logic for tests"
]

{ #category : #running }
SWZnWebSocket >> tearDown [
	client close.
	ZnServer default stop.
]

{ #category : #tests }
SWZnWebSocket >> testRequestGet [
	|res|
	client sendRequestGet: 'example.xml'.
	res := self readRequest.
	self assert: (res at: #method) equals: #GET.
	self assert: (res at: #target) asString equals: '/example.xml'.
	self assert: (res at: #type) equals: nil.
	self assert: (res at: #entity) equals: nil.
]

{ #category : #tests }
SWZnWebSocket >> testRequestPostJson [
	|res|
	client sendRequestPost: 'example.xml' with: { 'hogehoge' -> 123 }.
	res := self readRequest.
	self assert: (res at: #method) equals: #POST.
	self assert: (res at: #target) asString equals: '/example.xml'.
	self assert: (res at: #type) equals: ZnMimeType applicationJson.
	self assert: (res at: 'hogehoge') equals: 123.
]

{ #category : #tests }
SWZnWebSocket >> testRequestPutText [
	|res|
	client sendRequestPut: 'example.xml' with: { 'Creation' -> 'new' } entity: 'hogehoge'.
	res := self readRequest.
	self assert: (res at: #method) equals: #PUT.
	self assert: (res at: #target) asString equals: '/example.xml'.
	self assert: (res at: #type) sub equals: #plain.
	self assert: (res at: #Creation) equals: #new.
	self assert: (res at: #entity) equals: 'hogehoge'.
]

{ #category : #tests }
SWZnWebSocket >> testResponseBadRequest [
	|request res|
	request := ZnRequest get: 'example.html'.
	client sendResponseBadRequest: request.
	res := client readResponse.
	self assert: (res at: #code) equals: 400.
	self assert: (res at: #reason) equals: 'Bad Request'.
	self assert: (res at: #type) equals: ZnMimeType textPlain.
	self assert: (res at: #entity) equals: 'Bad Request GET /example.html', String crlf.

]

{ #category : #tests }
SWZnWebSocket >> testResponseCreated [
	|res|
	client sendResponseCreated: 'example.xml' with: { 'status' -> 'already existed' }.
	res := client readResponse.
	self assert: (res at: #code) equals: 201.
	self assert: (res at: #reason) equals: 'Created'.
	self assert: (res at: #Location) equals: 'example.xml'.
	self assert: (res at: #status) equals: 'already existed'.
]

{ #category : #tests }
SWZnWebSocket >> testResponseInternalServerError [
	|res|
	client sendResponseInternalServerError: { 'message' -> 'Something went wrong.'}.
	res := client readResponse.
	self assert: (res at: #code) equals: 500.
	self assert: (res at: #reason) equals: 'Internal Server Error'.
	self assert: (res at: #message) equals: 'Something went wrong.'.
]

{ #category : #tests }
SWZnWebSocket >> testResponseNotImplemented [
	|res|
	client sendResponseNotImplemented: { 'message' -> 'hogehoge' }.
	res := client readResponse.
	self assert: (res at: #code) equals: 501.
	self assert: (res at: #reason) equals: 'Not Implemented'.
	self assert: (res at: #message) equals: 'hogehoge'.

]

{ #category : #tests }
SWZnWebSocket >> testResponseOkText [
	|res|
	client sendResponseOk: { 'status' -> 'good' }.
	res := client readResponse.
	self assert: (res at: #code) equals: 200.
	self assert: (res at: #reason) asString equals: #OK.
	self assert: (res at: #status) equals: 'good'.
]
