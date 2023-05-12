"
A SWPipeTest is a test class for testing the behavior of SWPipe
"
Class {
	#name : #SWPipeTest,
	#superclass : #TestCase,
	#instVars : [
		'p',
		'done'
	],
	#category : #'SWFortranByPharo-ClientServer-Tests-Shell'
}

{ #category : #running }
SWPipeTest >> setUp [
	super setUp.

	p := SWPipe new.
	done := Semaphore new.
]

{ #category : #tests }
SWPipeTest >> test_Basics [
	|msg w r|
	msg := 'hello, world'.
	w := p writeStream.
	r := p readStream.
	w << msg; done.
	self assert: (String streamContents: [:s | s << r upToEnd ]) equals: msg
]

{ #category : #tests }
SWPipeTest >> test_BasicsForked [
	|msg w r readed|
	msg := 'hello, world'.
	w := p writeStream.
	r := p readStream.
	[
		r wait.
		readed := String streamContents: [:s | s << r upToEnd ].
		done signal.
	] fork.
	[
		w << msg; done.
	] fork.
	
	done wait.
	self assert: readed equals: msg.
]

{ #category : #tests }
SWPipeTest >> test_pipe [
	|tm|
	tm := SWTerminalMorph new openInWorld.
	[ :std |
		std << 'hello, '; done
	] | [ :std |
		std in wait.
		std << std upToEnd; << 'world'; done.
"		stderr << 'this is not an error.'; cr."
	] value: tm io.
	tm io wait.
	Processor yield.
	Processor yield.
	self assert: tm contents asString equals: ('hello, world', String cr)

]
