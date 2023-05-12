"
This implements shell execution using OSSubprocess.
"
Class {
	#name : #SWShell,
	#superclass : #Object,
	#instVars : [
		'scripts',
		'processes',
		'pipes',
		'leftMostPipe',
		'rightMostPipe',
		'errWriteStream',
		'semaphore'
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
	self leftMostPipe: inputStream readStream

]

{ #category : #comparing }
SWShell >> > outputStream [
	self rightMostPipe: outputStream writeStream
]

{ #category : #'initialize-release' }
SWShell >> close [
	processes
		do: [ :p | p terminate ];
		removeAll.
	pipes
		do: [ :p | p close ];
		removeAll.
	scripts removeAll.
]

{ #category : #testing }
SWShell >> closed [
	^ scripts isEmpty
]

{ #category : #accessing }
SWShell >> errWriteStream [

	^ errWriteStream ifNil: [ errWriteStream := self writeStream ]
]

{ #category : #accessing }
SWShell >> errWriteStream: anObject [

	errWriteStream := anObject
]

{ #category : #initialization }
SWShell >> initialize [
	super initialize.
	pipes := OrderedCollection new.
	processes := OrderedCollection new.
	scripts := OrderedCollection new.
	semaphore := Semaphore new.
]

{ #category : #accessing }
SWShell >> leftMostPipe [

	^ leftMostPipe ifNil: [ leftMostPipe := pipes add: SWPipe new ]
]

{ #category : #accessing }
SWShell >> leftMostPipe: anObject [

	leftMostPipe := anObject
]

{ #category : #'instance creation' }
SWShell >> newPipe [
	^ pipes add: SWPipe new.

]

{ #category : #enumerating }
SWShell >> newProcessDo: aBlock from: leftpipe to: rightpipe [
	processes add: [
		aBlock value: (SWStd new
			stdin: leftpipe readStream;
			stdout: rightpipe writeStream;
			stderr: self errWriteStream;
			yourself).
		semaphore signal
	] fork
]

{ #category : #accessing }
SWShell >> readStream [

	^ self rightMostPipe readStream
]

{ #category : #accessing }
SWShell >> rightMostPipe [

	^ rightMostPipe ifNil: [ rightMostPipe := pipes add: SWPipe new ]
]

{ #category : #accessing }
SWShell >> rightMostPipe: anObject [

	rightMostPipe := anObject
]

{ #category : #running }
SWShell >> run [
	|leftpipe rightpipe|
	scripts ifEmpty: [ ^ self ].
	semaphore initSignals.
	leftpipe := self leftMostPipe.
	scripts allButLastDo: [ :p |
		rightpipe := self newPipe.
		self newProcessDo: p from: leftpipe to: rightpipe.
		leftpipe := rightpipe.
	].
	rightpipe := self rightMostPipe.
	self newProcessDo: scripts last from: leftpipe to: rightpipe.

]

{ #category : #running }
SWShell >> runAndWait [
	self run; wait
]

{ #category : #waiting }
SWShell >> wait [
	processes do: [ :p | semaphore wait ]
]

{ #category : #accessing }
SWShell >> writeStream [

	^ self leftMostPipe writeStream
]

{ #category : #'logical operations' }
SWShell >> | aBlock [
	scripts add: aBlock
]
