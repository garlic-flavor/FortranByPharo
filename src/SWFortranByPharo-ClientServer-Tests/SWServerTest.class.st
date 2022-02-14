"
A SWServerTest is a test class for testing the behavior of SWServer
"
Class {
	#name : #SWServerTest,
	#superclass : #SWServerNodeTest,
	#category : #'SWFortranByPharo-ClientServer-Tests-Server'
}

{ #category : #running }
SWServerTest >> setUp [
	super setUp.
	SWServer start
]

{ #category : #running }
SWServerTest >> tearDown [
	SWServer stop.
	super tearDown.
]

{ #category : #test }
SWServerTest >> testCompileWithOn [
	|res|
	client sendRequestPost: 'native/helloworld.o' with: {
		'action' -> 'compile'.
		'type' -> 'f90'.
		'sources' -> { 'src/native/helloworld.f90' }
	}.
	res := client readResponse.
	self assert: (res at: #code) equals: 200.
	self deny: (res at: #status) equals: 'failed'.

]

{ #category : #test }
SWServerTest >> testExecWith [
	super testExecWith
]

{ #category : #test }
SWServerTest >> testFilePathOf [
self error; flag: #toRemove.
	self assert: (SWServer filePathOf: '/ruby') basename equals: 'ruby'
]

{ #category : #test }
SWServerTest >> testGetWithOn [
	|res|
	res := client ensureSendMessage: (SWServerInstruction new
		get;
		target: '/';
		toString).
	res inspect.

]

{ #category : #tests }
SWServerTest >> testHeadWithOn [
	|res|
	client sendRequestHead: 'src/native/helloworld.f90'.
	res := client readResponseHaltOnFailure.
	self assert: (res at: #code) equals: 200.
	self assert: (res at: #exists) equals: true.

]

{ #category : #test }
SWServerTest >> testLinkWithOn [
	|res|
	client sendRequestPost: 'helloworld.out' with: {
		'action' -> 'link'.
		'type' -> 'f90'.
		'sources' -> { 'obj/native/helloworld.o' }
	}.
	res := client readResponse.
	self assert: (res at: #code) equals: 200.
	self deny: (res at: #status) equals: 'failed'.

]

{ #category : #test }
SWServerTest >> testPostWithOn [
	|res|
	client sendRequestPost: 'src/native/helloworld.f90' with: { 'action' -> 'cat' }.
	res := client readResponse.
	self assert: (res at: #code) equals: 200.


]

{ #category : #test }
SWServerTest >> testPutContents [
	super testPutContents
]
