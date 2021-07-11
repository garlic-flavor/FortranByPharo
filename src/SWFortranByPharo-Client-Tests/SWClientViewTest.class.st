"
A SWClientViewTest is a test class for testing the behavior of SWClientView
"
Class {
	#name : #SWClientViewTest,
	#superclass : #TestCase,
	#instVars : [
		'view'
	],
	#category : #'SWFortranByPharo-Client-Tests-Client'
}

{ #category : #running }
SWClientViewTest >> setUp [
	super setUp.
	view := SWClientView new.
	ZnServer startDefaultOn: 50000.
	ZnServer default delegate: (ZnWebSocketDelegate handler: ZnWebSocketEchoHandler new).
	"Put here a common initialization logic for tests"
]

{ #category : #running }
SWClientViewTest >> tearDown [
	super tearDown.
	view socket close.
	ZnServer default stop.
]

{ #category : #tests }
SWClientViewTest >> testPut [

]

{ #category : #tests }
SWClientViewTest >> testSocket [
	|received|
	self assert: view socket isConnected.
	view socket sendRequestGet: '/'.
	received := view socket readMessage asString.
	self assert: received equals: (String crlf join: {
		'GET / HTTP/1.1'.
		'User-Agent: Zinc HTTP Components 1.0 (Pharo/9.0)'.
		'Accept: */*'.
		''. ''
	}).
]
