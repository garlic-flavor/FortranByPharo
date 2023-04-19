Class {
	#name : #SWShellProcess,
	#superclass : #Object,
	#instVars : [
		'io'
	],
	#category : #'SWFortranByPharo-ClientServer-Shell'
}

{ #category : #'as yet unclassified' }
SWShellProcess class >> redirect: aStream to: aQueue [
	[|m|
		m := Monitor new.
		[
			m critical: [
				m waitWhile: [ aStream atEnd ].
				aQueue << aStream upToEnd
			].
			aStream closed.
		] whileFalse
	] fork
]

{ #category : #enumerating }
SWShellProcess >> do: aBlock [
	^ aBlock value: self io
]

{ #category : #execution }
SWShellProcess >> execute: command [
	^ self executeProcess: (OSSUnixSubprocess new
		shellCommand: command;
		yourself)
]

{ #category : #execution }
SWShellProcess >> execute: exe arguments: list [
	"I execute 'exe' with 'list', then return its result."
	^ self executeProcess: (OSSUnixSubprocess new
			command: exe;
			arguments: list;
			yourself)

]

{ #category : #execution }
SWShellProcess >> executeProcess: process [

	process
		workingDirectory: SWOS default localDirectory fullName;
		redirectStdout;
		redirectStderr.
	self class
		redirect: process stdoutStream to: self io outputStream;
		redirect: process stderrStream to: self io errStream.
	^ process
		runAndWaitOnExitDo: [ :p :out :err |
			out ifNotEmpty: [
				self io outputStream << out
			].
			err ifNotEmpty: [
				self io errStream << err
			]
		];
		isSuccess

]

{ #category : #accessing }
SWShellProcess >> io [

	^ io ifNil: [ io := SWIO new ]
]

{ #category : #accessing }
SWShellProcess >> io: anObject [

	io := anObject
]
