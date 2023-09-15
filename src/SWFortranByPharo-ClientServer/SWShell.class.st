"
This implements shell execution using OSSubprocess.
"
Class {
	#name : #SWShell,
	#superclass : #Object,
	#category : #'SWFortranByPharo-ClientServer-Shell'
}

{ #category : #'as yet unclassified' }
SWShell class >> decode_self: cdt [
	(cdt pool getClassInfo: OSEnvironment class)
		declareMethodReturnsReceiversInstance: #current.

	(cdt pool getClassInfo: OSSUnixSubprocess)
		declareMethod: #createADefaultWriteStream asReturn: WriteStream";
		declareMethod: #shellCommand asReturn: String;
		declareMethodReturnsReceiver: #shell:command:;
		declareMethod: #waitForExit asReturn: SmallInteger;
		declareMethod: #isSuccess asReturn: Boolean;
		declareMethodReturnsReceiver: #initialize"

]

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

{ #category : #'as yet unclassified' }
SWShell class >> execute: exe redirectTo: io [
	^ OSSUnixSubprocess new
		command: exe;
		arguments: io args;
		workingDirectory: SWOS default localDirectory fullName;
		redirectStdinTo: io in;
		redirectStdoutTo: io out;
		redirectStderrTo: io err;
		runAndWait;
		yourself.
]

{ #category : #execution }
SWShell class >> executeProcess: process [
	"I execute 'exe' with 'list', then return its result."
	SWType declare: #return as: String.
	^ [
		process
			workingDirectory: SWOS default localDirectory fullName;
			redirectStdout;
			redirectStderr;
			runAndWait.
		process isSuccess
				ifTrue: [ process stdoutStream upToEnd ]
				ifFalse: [ self error: process stderrStream upToEnd ].
	] ensure: [ process ifNotNil: [ process closeAndCleanStreams ] ]

]

{ #category : #converting }
SWShell class >> filePathOf: aName [
	|path|
	path := SWOS default localDirectory / aName.
	(SWOS default localDirectory contains: path) ifFalse: [
		self error: aName, ' is out of the local directory.'
	].
	path parent ensureCreateDirectory.
	^ path

]

{ #category : #execution }
SWShell class >> ls: path [
	self error; flag: #toRemove.
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
	self error; flag: #toRemove.
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

{ #category : #pipes }
SWShell class >> makeBlockingPipe [
	^ OSSVMProcess vmProcess systemAccessor makeBlockingPipe
]

{ #category : #pipes }
SWShell class >> makeNonBlockingPipe [
	^ OSSVMProcess vmProcess systemAccessor makeNonBlockingPipe
]

{ #category : #requesting }
SWShell class >> put: target contents: contents [
	|file|
	file := self filePathOf: target.
	file parent ensureCreateDirectory.
	file writeStreamDo: [ :writer |
		SWType declare: #writer as: BinaryFileStream.
		writer 
			position: 0;
			truncate;
			<< contents.
	].
	^ file
]

{ #category : #'as yet unclassified' }
SWShell class >> solveDependencies: mt [
	SWOS solveDependencies: mt.
	mt
		transpile: SWOS;
		import: #(OSSUnixSubprocess) from: 'OSSUnixSubprocess'
]
