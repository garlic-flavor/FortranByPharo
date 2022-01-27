"
This implements shell execution using OSSubprocess.
"
Class {
	#name : #SWShell,
	#superclass : #Object,
	#category : #'SWFortranByPharo-ClientServer-Shell'
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
	^ [
		process
			workingDirectory: SWShellEnvironment default localDirectory fullName;
			redirectStdout;
			redirectStderr;
			runAndWait.
		process isSuccess
				ifTrue: [ process stdoutStream upToEnd ]
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
			ifTrue: [path children collect: [ :each |
				Dictionary new
					at: #isDirectory put: each isDirectory;
					at: #basename put: each basename;
					at: #path put: (each relativeTo: FileLocator imageDirectory) fullName;
					at: #creationTime put: each creationTime prettyPrint;
					at: #children put: nil;
					yourself
			]] ifFalse: [ nil ]);
		yourself.

]

{ #category : #execution }
SWShell class >> lsr: path [
	^ Dictionary new
		at: #isDirectory put: path isDirectory;
		at: #basename put: path basename;
		at: #path put: (path relativeTo: FileLocator imageDirectory) fullName;
		at: #creationTime put: path creationTime prettyPrint;
		at: #children put: (path isDirectory
			ifTrue: [(path children collect: [ :each | self lsr: each ])]
			ifFalse: [ { } ]
		);
		yourself.


]

{ #category : #'code generation' }
SWShell class >> mjs_requirements: transpiler [
	self error; flag: #toRemove.
	transpiler
		putImportNative: {'PharoObject'. 'Dictionary'. 'FileLocator' } from: 'Pharo.mjs';
		putImportNative: 'OSSUnixSubprocess' from: 'OSSUnixSubprocess.mjs';
		putImportClass: SWShellEnvironment
]

{ #category : #'code generation' }
SWShell class >> rb_requirements [
	self error; flag: #toRemove.
	^ { 'OSSUnixSubprocess.rb' }
]

{ #category : #'as yet unclassified' }
SWShell class >> solveDependenciesUsing: transpiler [
	transpiler
		transpile: SWShellEnvironment;
		import: #(OSSUnixSubprocess) from: 'OSSUnixSubprocess'
]
