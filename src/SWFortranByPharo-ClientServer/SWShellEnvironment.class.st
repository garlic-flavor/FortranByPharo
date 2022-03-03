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
		'localDirectory',
		'packageName'
	],
	#classInstVars : [
		'default'
	],
	#category : #'SWFortranByPharo-ClientServer-Shell'
}

{ #category : #initialization }
SWShellEnvironment class >> decode_OSEnvironmentClass: ct [
	self error; flag: #toRemove.
	ct
		declareMethodReturnsReceiversInstance: #environmentFor:

]

{ #category : #initialization }
SWShellEnvironment class >> decode_OSPlatformClass: ct [
	self error; flag: #toRemove.
	ct
		declareMethodReturnsReceiversInstance: #current
]

{ #category : #initialization }
SWShellEnvironment class >> decode_OSSUnixSubprocess: ct [
	self error; flag: #toRemove.
	ct
		declareMethodReturnsReceiver: #run;
		declareMethodReturnsReceiver: #initialize

]

{ #category : #'as yet unclassified' }
SWShellEnvironment class >> decode_self: cdt [
	cdt
		declareMethod: #localDirectory asReturn: FileLocator.


]

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

{ #category : #initialization }
SWShellEnvironment class >> resetDefault [
	<script>
	default := nil
]

{ #category : #initialization }
SWShellEnvironment class >> setUpDecoder: global [
	self error; flag: #toRemove.
	(global getClassInfo: OSEnvironment class)
		declareMethodReturnsReceiversInstance: #environmentFor:.
	(global getClassInfo: OSPlatform class)
		declareMethodReturnsReceiversInstance: #current.
	(global getClassInfo: OSSUnixSubprocess)
		declareMethodReturnsReceiver: #run;
		declareMethodReturnsReceiver: #initialize.

	(global getClassInfo: SWShellEnvironment)
		declareMethod: #localDirectory asReturn: FileLocator.

]

{ #category : #initialization }
SWShellEnvironment class >> setUpTranspiler:  mt [
	(mt global getClassInfo: OSEnvironment class)
		declareMethodReturnsReceiversInstance: #environmentFor:.
	(mt global getClassInfo: OSPlatform class)
		declareMethodReturnsReceiversInstance: #current.
	(mt global getClassInfo: OSSUnixSubprocess)
		declareMethodReturnsReceiver: #run;
		declareMethodReturnsReceiver: #initialize.

	(mt pool getClassInfo: SWShellEnvironment)
		methodBodyTranspilerOf: #localDirectory is: [ :mbt |
			mbt
				put: 'return FileLocator.localDirectory()';
				putStatementDelimiter;
				cr
		].

]

{ #category : #private }
SWShellEnvironment class >> solveDependencies: mt [
	mt
		transpile: SWGFortranCompilerAdapter;
		import: #(OSPlatform FileLocator) from: 'Pharo'
]

{ #category : #'as yet unclassified' }
SWShellEnvironment class >> solveDependenciesUsing: pool [
	self error; flag: #toRemove.
	(pool global getClassInfo: OSEnvironment class)
		declareMethodReturnsReceiversInstance: #environmentFor:.
	(pool global getClassInfo: OSPlatform class)
		declareMethodReturnsReceiversInstance: #current.
	(pool global getClassInfo: OSSUnixSubprocess)
		declareMethodReturnsReceiver: #run;
		declareMethodReturnsReceiver: #initialize.

	(pool global getClassInfo: SWShellEnvironment)
		declareMethod: #localDirectory asReturn: FileLocator.

	(pool getClassInfo: SWShellEnvironment)
		methodBodyTranspilerOf: #localDirectory is: [ :mbt |
			mbt
				put: 'return FileLocator.localDirectory()';
				putStatementDelimiter;
				cr
		].

	pool
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
		localDirectory := ((IceRepository repositories detect: [ :each |
			each name = self packageName
		]) location)
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

{ #category : #accessing }
SWShellEnvironment >> packageName [

	^ packageName ifNil: [ packageName := 'FortranByPharo' ]
]

{ #category : #accessing }
SWShellEnvironment >> packageName: anObject [

	packageName := anObject.
	localDirectory := nil
]
