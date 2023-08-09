"
A SWStreamWaiterTest is a test class for testing the behavior of SWStreamWaiter
"
Class {
	#name : #SWStreamWaiterTest,
	#superclass : #TestCase,
	#instVars : [
		'pipe',
		'done'
	],
	#category : #'SWFortranByPharo-ClientServer-Tests-Shell'
}

{ #category : #running }
SWStreamWaiterTest >> setUp [
	super setUp.

	pipe := SWWaitableStream newOnPipe.
	done := Semaphore new.

	"Put here a common initialization logic for tests"
]

{ #category : #running }
SWStreamWaiterTest >> tearDown [
	pipe close.
	super tearDown
]

{ #category : #tests }
SWStreamWaiterTest >> test_Basics [
	|msg read|
	[
		pipe wait.
		read := pipe readLn.
		done signal.
	] fork.
	msg := 'hello, world!'.
	pipe nextPutAll: msg; ln.
	done wait.
	self assert: read equals: (msg, String lf)
]
