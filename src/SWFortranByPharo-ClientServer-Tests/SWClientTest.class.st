Class {
	#name : #SWClientTest,
	#superclass : #TestCase,
	#instVars : [
		'client',
		'server'
	],
	#category : #'SWFortranByPharo-ClientServer-Tests-Client'
}

{ #category : #running }
SWClientTest >> setUp [

	super setUp.
	server := SWTestServer new
		start;
		yourself.
	client := SWClient new
]

{ #category : #running }
SWClientTest >> tearDown [

	server stop.
 	super tearDown
]

{ #category : #tests }
SWClientTest >> testExecWith [

	| tmp1 |
	tmp1 := client exec: 'node' with: { '-v' }.
	self assert: tmp1 message equals: '/execute?target=node&args=-v'
]

{ #category : #tests }
SWClientTest >> testGet [

	| tmp1 |
	tmp1 := client get: 'hogehoge'.
	self
		assert: (self toCr: tmp1)
		equals: 'GET /manage?target=hogehoge HTTP/1.1
User-Agent: Zinc HTTP Components 1.0 (Pharo/10.0)
Accept: */*
Host: localhost:50000
X-Zinc-Remote-Address: 127.0.0.1

'
]

{ #category : #tests }
SWClientTest >> testHead [

	| tmp1 |
	tmp1 := client head: 'hoge.txt'.
	self assert: tmp1 equals: 'last modified time'

]

{ #category : #tests }
SWClientTest >> testPost [
	|dict|
	dict := Dictionary newFrom: { 
		#type -> 'f90'.
		#action -> 'go'.
		#sources -> { 'hello.f90'. 'standard.dylib' }.
		#options -> {}.
		#out -> 'a.out'
	}.
	(ZnClient new
		http;
		host: 'localhost';
		port: 50000;
		addPathSegment: 'manage';
		enforceHttpSuccess: true;
		contents: (STONJSON toString: dict);
		post;
		response) inspect.
]

{ #category : #tests }
SWClientTest >> testPut [

	| tmp1 |
	tmp1 := client put: 'hoge.txt' contents: 'Hello, World!'.
	self assert: tmp1 equals: 'last modified time'

]

{ #category : #'as yet unclassified' }
SWClientTest >> toCr: arg1 [

	^ arg1 copyReplaceAll: String crlf with: String cr
]
