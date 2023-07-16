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
		w << msg; done.
	] fork.
	
	done wait.
	self assert: readed equals: msg.
]

{ #category : #tests }
SWPipeTest >> test_pipe [
	|tm|
	tm := SWTerminalMorph new openInWorld.
	tm do: [ :std |
		std << 'hello, '; done
	] | [ :std |
		std in wait.
		std << std upToEnd; << 'world'; ln.
		(std err) << 'this is not an error.'; done.
	].
	tm std out wait.
	self assert: tm contents asString equals: ('hello, world', String cr, 'this is not an error.')

]

{ #category : #tests }
SWPipeTest >> test_pipeToFile [
	|filepath file std|
	filepath := SWShell filePathOf: 'hoge.txt'.
	file := File openForWriteFileNamed: filepath pathString.
	std := SWStd new
		> file;
		yourself.
	std << 'hello, world'.
	std close.
	file close.
	file := File openForReadFileNamed: filepath pathString.
	self assert: file upToEnd asString equals: 'hello, world'.
	File deleteFile: filepath pathString.

]
