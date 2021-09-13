"
A SWClientTest is a test class for testing the behavior of SWClient
"
Class {
	#name : #SWClientTest,
	#superclass : #TestCase,
	#instVars : [
		'client',
		'server'
	],
	#category : #'SWFortranByPharo-Client-Tests-Client'
}

{ #category : #running }
SWClientTest >> setUp [
	super setUp.
	server := SWTestServer new start; yourself.
	client := SWClient new.


]

{ #category : #running }
SWClientTest >> tearDown [
	client close.
	server stop.
	super tearDown.
	
]

{ #category : #tests }
SWClientTest >> testGet [
	|res|
	res := client get: 'hogehoge'.
	self assert: (self toCr: res) equals: 'GET /manage?target=hogehoge HTTP/1.1
User-Agent: Zinc HTTP Components 1.0 (Pharo/9.0)
Accept: */*
Host: localhost:50000
X-Zinc-Remote-Address: 127.0.0.1

'
]

{ #category : #'as yet unclassified' }
SWClientTest >> toCr: string [
	^ string copyReplaceAll: String crlf with: String cr
]
