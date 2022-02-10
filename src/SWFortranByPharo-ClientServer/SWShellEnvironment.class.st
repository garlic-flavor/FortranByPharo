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

{ #category : #accessing }
SWShellEnvironment class >> default [
	^ default ifNil: [ default := self newDefault ]

]

{ #category : #initialization }
SWShellEnvironment class >> initializeInstanceSideTranspiler: transpiler [
	self error; flag: #toReimplement.
	transpiler
		declareMethod: #localDirectory as: [ :newT |
			newT
				specifyReturnTypeAs: FileLocator;
				markAsDecoded;
				generator: [ :t |
					t
						put: 'return FileLocator.localDirectory()';
						putStatementDelimiter;
						cr
				];
				yourself
		]
]

{ #category : #initialization }
SWShellEnvironment class >> initialize_OSEnvironmentClass: ct [
	ct
		declareMethodReturnsReceiversInstance: #environmentFor:

]

{ #category : #initialization }
SWShellEnvironment class >> initialize_OSSUnixSubprocess: ct [
	ct
		declareMethodReturnsReceiver: #run;
		declareMethodReturnsReceiver: #initialize

]

{ #category : #initialization }
SWShellEnvironment class >> initialize_self: transpiler [
	transpiler
		declareMethod: #localDirectory asReturn: FileLocator;
		defineMethodBody: #localDirectory as: [ :t |
			t
				put: 'return FileLocator.localDirectory()';
				putStatementDelimiter;
				cr
		]
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
