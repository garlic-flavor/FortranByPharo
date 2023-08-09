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
	#category : #'SWFortranByPharo-ClientServer-toRemove'
}

{ #category : #running }
SWPipeTest >> setUp [
	super setUp.

	p := SWPipetoRemove new.
	done := Semaphore new.
]

{ #category : #tests }
SWPipeTest >> test_Basics [
	|msg w r|
	msg := 'hello, world'.
	w := p writeStream.
	r := p readStream.
	w << msg; done.
	self assert: (String readFrom: r) equals: msg
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
		w << msg; ln.
	] fork.
	
	done wait.
	self assert: readed equals: msg.
]

{ #category : #tests }
SWPipeTest >> test_BasicsForked2 [
	|msg w r readed|
	msg := 'hello, world'.
	w := p writeStream.
	r := p readStream.
	[
		r wait.
		readed := String streamContents: [:s | s << r upToEnd ].
	] fork.
	[
		w << msg; ln.
	] fork.

	Processor yield.
	w waitReady.

	self assert: readed equals: msg.
]

{ #category : #tests }
SWPipeTest >> test_pipe [
	|tm|
	tm := SWTerminalMorphtoRemove new openInWorld.
	tm do: [ :io |
		io << 'hello, '; ln
	] | [ :io |
		io in wait.
		io << io upToEnd; << 'world'; ln.
		(io err) << 'this is not an error.'; ln.
	].
	self assert: tm contents asString equals:
		('hello, world', String cr, 'this is not an error.', String cr)
]

{ #category : #tests }
SWPipeTest >> test_pipeToFile [
	|filepath file std|
	filepath := SWShell filePathOf: 'hoge.txt'.
	file := File openForWriteFileNamed: filepath pathString.
	std := SWIO new
		> file;
		yourself.
	std << 'hello, world'; ln.
	std close.
	file close.
	file := File openForReadFileNamed: filepath pathString.
	self assert: file upToEnd asString equals: ('hello, world', String cr).
	File deleteFile: filepath pathString.

]
