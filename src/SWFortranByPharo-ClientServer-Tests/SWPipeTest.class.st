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
	w := p writer.
	r := p reader.
	w << msg; cr.
	self assert: r nextLine equals: msg
]

{ #category : #tests }
SWPipeTest >> test_BasicsForked [
	|msg w r readed|
	msg := 'hello, world'.
	w := p writer.
	r := p reader.
	[
		r wait.
		readed := r nextLine.
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
	tm := SWTerminalMorph new.
	SWShell new
		| [ :stdin :stdout :stderr |
			stdout << 'hello, '; cr
		];
		| [ :stdin :stdout :stderr |
			stdin wait.
			stdout << stdin nextLine; << 'world'; cr.
			stderr << 'this is not an error.'; cr.
		] redirectErrToOut;
		< tm;
		> tm;
		runAndWait
]
