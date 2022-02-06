"
This contains the information about development environment.
"
Class {
	#name : #SWShellEnvironment,
	#superclass : #Object,
	#instVars : [
		'exeFileExtension',
		'objFileExtension',
		'fortranCompilerAdapterClass',
		'localDirectory'
	],
	#classInstVars : [
		'default'
	],
	#category : #'SWFortranByPharo-ClientServer-Shell'
}

{ #category : #adding }
SWShellEnvironment class >> addTranspilerTo: pool [
	pool
		addTranspilerOf: SWShellEnvironment initialize: [ :ct |
			ct
				defineMethod: #localDirectory asReturn: FileLocator
		];
		addTranspilerOf: SWShellEnvironment class initialize: [ :ct |
			ct
				defineMethodReturnsReceiversInstance: #default
		];
		addTranspilerOf: OSEnvironment class initialize: [ :ct |
			ct
				defineMethodReturnsReceiversInstance: #environmentFor:
		];
		addTranspilerOf: OSSUnixSubprocess initialize: [ :ct |
			ct
				defineMethodReturnsReceiver: #run;
				defineMethodReturnsReceiver: #initialize;
				defineMethodReturnsReceiver: #command:;
				defineMethodReturnsReceiver: #arguments:;
				defineMethod: #waitForExit asReturn: Integer;
				defineMethod: #isSuccess asReturn: Boolean
		]
]

{ #category : #accessing }
SWShellEnvironment class >> default [
	^ default ifNil: [ default := self newDefault ]

]

{ #category : #initialization }
SWShellEnvironment class >> initializeInstanceSideTranspiler: transpiler [

	transpiler
		defineMethod: #localDirectory as: [ :newT |
			newT
				specifyReturnTypeAs: FileLocator;
				markAsDecoded;
				bodyGenerator: [ :t |
					t
						put: 'return FileLocator.localDirectory()';
						putStatementDelimiter;
						cr
				];
				yourself
		]
]

{ #category : #'code generation' }
SWShellEnvironment class >> mjs_localDirectoryUsing: transpiler [
	self error; flag: #toRemove.
	transpiler put: 'return new FileLocator(process.cwd());'
]

{ #category : #'code generation' }
SWShellEnvironment class >> mjs_requirements: transpiler [
	self error; flag: #toRemove.
	transpiler
		putImportNative: #(PharoObject OSPlatform SWGFortranCompilerAdapter FileLocator)  from: 'Pharo.mjs'
]

{ #category : #'instance creation' }
SWShellEnvironment class >> newDefault [
	OSPlatform current isMacOS ifTrue: [ 
		^ self newMacDefault
	].
	self error: 'This machine is not supported.'.

]

{ #category : #'instance creation' }
SWShellEnvironment class >> newMacDefault [
	^ self new
		fortranCompilerAdapterClass: SWGFortranCompilerAdapter;
		exeFileExtension: #out;
		objFileExtension: #o;
		yourself.
]

{ #category : #'as yet unclassified' }
SWShellEnvironment class >> solveDependenciesUsing: transpiler [
	transpiler
		transpile: SWGFortranCompilerAdapter;
		import: #(OSPlatform FileLocator) from: 'Pharo'
]

{ #category : #accessing }
SWShellEnvironment >> exeFileExtension [

	^ exeFileExtension
]

{ #category : #accessing }
SWShellEnvironment >> exeFileExtension: anObject [

	exeFileExtension := anObject
]

{ #category : #accessing }
SWShellEnvironment >> fortranCompilerAdapterClass [

	^ fortranCompilerAdapterClass
]

{ #category : #accessing }
SWShellEnvironment >> fortranCompilerAdapterClass: anObject [

	fortranCompilerAdapterClass := anObject
]

{ #category : #origins }
SWShellEnvironment >> localDirectory [
	^ localDirectory ifNil: [
		localDirectory := ((IceRepository repositories select: [ :each |
			each name = #FortranByPharo
		]) first location)
	]
]

{ #category : #accessing }
SWShellEnvironment >> objFileExtension [

	^ objFileExtension
]

{ #category : #accessing }
SWShellEnvironment >> objFileExtension: anObject [

	objFileExtension := anObject
]
