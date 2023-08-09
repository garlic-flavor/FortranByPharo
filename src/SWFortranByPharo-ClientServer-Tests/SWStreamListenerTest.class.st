"
A SWPipeWatcherTest is a test class for testing the behavior of SWPipeWatcher
"
Class {
	#name : #SWStreamListenerTest,
	#superclass : #TestCase,
	#instVars : [
		'pipe',
		'done'
	],
	#category : #'SWFortranByPharo-ClientServer-Tests-Shell'
}

{ #category : #running }
SWStreamListenerTest >> setUp [
	super setUp.
	pipe := SWStreamListener newOnPipe.
	done := Semaphore new.
	"Put here a common initialization logic for tests"
]

{ #category : #running }
SWStreamListenerTest >> tearDown [
	pipe close.
	super tearDown.
]

{ #category : #tests }
SWStreamListenerTest >> test_Basics [ 
	|input output|
	pipe callback: [ :txt |
		output := txt.
		done signal.
	].

	input := 'Hello, world!', String lf.
	pipe nextPutAll: input; flush.
	done wait.
	self assert: input equals: output

]
