"
This implements shell execution using OSSubprocess.
"
Class {
	#name : #SWShell,
	#superclass : #Object,
	#category : #'SWFortranByPharo-Server-Shell'
}

{ #category : #execution }
SWShell class >> execute: exe arguments: list [
	"I execute 'exe' with 'list', then return its result."
	| result |
	result := SWShellResult new isSuccess: false.
	[
		| process |
		process := OSSUnixSubprocess new
			command: exe;
			arguments: list;
			redirectStdout;
			redirectStderr.
		[
			process runAndWait.
			process isSuccess
					ifTrue: [ result isSuccess: true; message: process stdoutStream upToEnd ]
					ifFalse: [ result message: process stderrStream upToEnd ].
		] ensure: [ process ifNotNil: [ process closeAndCleanStreams ] ]
	] on: Error do: [ :ex |
		result message: ex printString.
		ex isResumable
			ifTrue: [ ex resume ]
	].

	^ result
]
