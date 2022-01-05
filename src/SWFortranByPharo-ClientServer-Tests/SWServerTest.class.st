"
A SWServerTest is a test class for testing the behavior of SWServer
"
Class {
	#name : #SWServerTest,
	#superclass : #SWTestBase,
	#category : #'SWFortranByPharo-ClientServer-Tests'
}

{ #category : #'as yet unclassified' }
SWServerTest class >> rb_requirements [
	^ { SWServer }
]

{ #category : #running }
SWServerTest >> setUp [
	super setUp.
	"Put here a common initialization logic for tests"
]

{ #category : #running }
SWServerTest >> tearDown [
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
SWServerTest >> testExecWithOn [
	|res|
	client sendRequestPost: 'exe/helloworld.out' with: {
		'action' -> 'execute'.
		'arguments' -> { }
	}.
	res := client readResponse.
	self assert: (res at: #code) equals: 200.
	self assert: (res at: #status) equals: 'ok'.
	self assert: (res at: #stdout) equals: ' Hello, World!', String lf.


]

{ #category : #test }
SWServerTest >> testFilePathOf [

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

{ #category : #tests }
SWServerTest >> testPutSelf [
	(self
		type: #rb;
		runAsClient: true;
		usingPharoServer: true;
		source) inspect.
]

{ #category : #test }
SWServerTest >> testPutWithOn [
	|res|
	client sendRequestPut: 'test.txt' with: { 'Creation-Mode' -> 'new' } entity: 'Hello, World!'.
	res := client readResponse.
	self assert: (res at: #code) equals: 201.
	self assert: (res at: #Location) equals: 'test.txt'.
]
