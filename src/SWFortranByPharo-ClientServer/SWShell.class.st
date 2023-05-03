"
This implements shell execution using OSSubprocess.
"
Class {
	#name : #SWShell,
	#superclass : #Object,
	#instVars : [
		'processes',
		'pipes',
		'semaphores',
		'reader',
		'writer',
		'errWriter'
	],
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

{ #category : #initialization }
SWShell class >> setupTranspiler: pool [
"
	SWShellEnvironment setUpTranspiler: pool.

	(pool global getClassInfo: OSEnvironment class)
		declareMethodReturnsReceiversInstance: #current.

	(pool global getClassInfo: OSSUnixSubprocess)
		declareMethod: #createADefaultWriteStream asReturn: WriteStream"";
		declareMethod: #shellCommand asReturn: String;
		declareMethodReturnsReceiver: #shell:command:;
		declareMethod: #waitForExit asReturn: SmallInteger;
		declareMethod: #isSuccess asReturn: Boolean;
		declareMethodReturnsReceiver: #initialize"
""
]

{ #category : #'as yet unclassified' }
SWShell class >> solveDependencies: mt [
	SWOS solveDependencies: mt.
	mt
		transpile: SWOS;
		import: #(OSSUnixSubprocess) from: 'OSSUnixSubprocess'
]

{ #category : #comparing }
SWShell >> < inputStream [
	self readStream: inputStream readStream
]

{ #category : #comparing }
SWShell >> > outputStream [
	self writeStream: outputStream writeStream
]

{ #category : #accessing }
SWShell >> errWriteStream [

	^ errWriter ifNil: [ errWriter := self writeStream ]
]

{ #category : #accessing }
SWShell >> errWriteStream: anObject [

	errWriter := anObject
]

{ #category : #accessing }
SWShell >> pipes [

	^ pipes ifNil: [ pipes := OrderedCollection new ]
]

{ #category : #accessing }
SWShell >> pipes: anObject [

	pipes := anObject
]

{ #category : #accessing }
SWShell >> processes [

	^ processes ifNil: [ processes := OrderedCollection new ]
]

{ #category : #accessing }
SWShell >> processes: anObject [

	processes := anObject
]

{ #category : #accessing }
SWShell >> readStream [

	^ reader ifNil: [ reader := String empty readStream ]
]

{ #category : #accessing }
SWShell >> readStream: anObject [

	reader := anObject
]

{ #category : #running }
SWShell >> run [
	|leftpipe rightpipe|
	leftpipe := SWPipe new
		stdStream: self readStream;
		yourself.
	rightpipe := SWPipe new.
	self processes allButLastDo: [ :process|
		[
			process value: leftpipe readStream value: rightpipe writeStream value: self errWriteStream.
		] fork.
		leftpipe := rightpipe
	].
	rightpipe := SWPipe new
		stdStream: self writeStream;
		yourself.
	[
		processes last value: leftpipe readStream value: rightpipe writeStream value: self errWriteStream
	] fork
]

{ #category : #running }
SWShell >> runAndWait [
	self halt.
]

{ #category : #accessing }
SWShell >> semaphores [

	^ semaphores ifNil: [ semaphores := OrderedCollection new ]
]

{ #category : #accessing }
SWShell >> semaphores: anObject [

	semaphores := anObject
]

{ #category : #accessing }
SWShell >> writeStream [

	^ writer ifNil: [ writer := String new writeStream ]
]

{ #category : #accessing }
SWShell >> writeStream: anObject [

	writer := anObject
]

{ #category : #'logical operations' }
SWShell >> | aBlock [
	self processes add: aBlock
]
