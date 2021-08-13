"
This implements shell execution using OSSubprocess.
"
Class {
	#name : #SWShell,
	#superclass : #Object,
	#category : #'SWFortranByPharo-Server-Shell'
}

{ #category : #execution }
SWShell class >> execute: command [
	"I execute 'exe' with 'list', then return its result."
	^ self executeProcess: (OSSUnixSubprocess new
			shellCommand: command;
			yourself)

]

{ #category : #execution }
SWShell class >> execute: exe arguments: list [
	"I execute 'exe' with 'list', then return its result."
	^ self executeProcess: (OSSUnixSubprocess new
			command: exe;
			arguments: list;
			yourself)

]

{ #category : #execution }
SWShell class >> executeProcess: process [
	"I execute 'exe' with 'list', then return its result."
	[
		process
			redirectStdout;
			redirectStderr;
			runAndWait.
		process isSuccess
				ifTrue: [ ^ process stdoutStream upToEnd ]
				ifFalse: [ self error: process stderrStream upToEnd ].
	] ensure: [ process ifNotNil: [ process closeAndCleanStreams ] ]

]

{ #category : #execution }
SWShell class >> ls: path [
	^ Dictionary new
		at: #isDirectory put: path isDirectory;
		at: #basename put: path basename;
		at: #path put: (path relativeTo: FileLocator imageDirectory) fullName;
		at: #creationTime put: path creationTime prettyPrint;
		at: #children put: (path isDirectory
			ifTrue: [(path children collect: [ :each | self ls: each ])]
			ifFalse: [ { } ]
		);
		yourself.


]

{ #category : #'code generation' }
SWShell class >> rb_ls_using: transpiler [

]

{ #category : #'code generation' }
SWShell class >> rb_requirements [
	^ { 'OSSUnixSubprocess.rb' }
]
