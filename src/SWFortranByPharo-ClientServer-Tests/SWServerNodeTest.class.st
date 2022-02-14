Class {
	#name : #SWServerNodeTest,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-ClientServer-Tests-Server'
}

{ #category : #running }
SWServerNodeTest >> setUp [
	super setUp.

]

{ #category : #running }
SWServerNodeTest >> tearDown [
	SWServer stop.

]

{ #category : #test }
SWServerNodeTest >> testCompileWithOn [
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
SWServerNodeTest >> testExecWith [
	|res message|
	message := 'Hello, world!'.
	res := SWClient new exec: 'echo' with: { message }.
	self assert: res code equals: 'ok'.
	self assert: res message trimRight equals: message.

]

{ #category : #test }
SWServerNodeTest >> testFilePathOf [
	self error; flag: #toRemove.
	self assert: (SWServer filePathOf: '/ruby') basename equals: 'ruby'
]

{ #category : #test }
SWServerNodeTest >> testGetWithOn [
	|res|
	res := client ensureSendMessage: (SWServerInstruction new
		get;
		target: '/';
		toString).
	res inspect.

]

{ #category : #tests }
SWServerNodeTest >> testHeadWithOn [
	|res|
	client sendRequestHead: 'src/native/helloworld.f90'.
	res := client readResponseHaltOnFailure.
	self assert: (res at: #code) equals: 200.
	self assert: (res at: #exists) equals: true.

]

{ #category : #test }
SWServerNodeTest >> testLinkWithOn [
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
SWServerNodeTest >> testPostWithOn [
	|res|
	client sendRequestPost: 'src/native/helloworld.f90' with: { 'action' -> 'cat' }.
	res := client readResponse.
	self assert: (res at: #code) equals: 200.


]

{ #category : #test }
SWServerNodeTest >> testPutContents [
	|res|
	res := SWClient new put: 'test.txt' contents: 'Hello, world!'.
	self assert: (DateAndTime readFrom: res readStream) asDate equals: Date today
]
