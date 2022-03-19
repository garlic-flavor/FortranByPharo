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

{ #category : #'as yet unclassified' }
SWShellEnvironment class >> decode_self: cdt [
	cdt
		declareMethod: #localDirectory asReturn: FileLocator.

]

{ #category : #accessing }
SWShellEnvironment class >> default [
	^ default ifNil: [ default := self newDefault ]

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
SWShellEnvironment class >> setUpTranspiler:  mt [
	(mt global getClassInfo: OSEnvironment class)
		declareMethodReturnsReceiversInstance: #environmentFor:.
	(mt global getClassInfo: OSPlatform class)
		declareMethodReturnsReceiversInstance: #current.
	(mt global getClassInfo: OSSUnixSubprocess)
		declareMethodReturnsReceiver: #run;
		declareMethodReturnsReceiver: #initialize.


]

{ #category : #private }
SWShellEnvironment class >> solveDependencies: mt [
	mt
		transpile: SWGFortranCompilerAdapter;
		import: #(OSPlatform FileLocator) from: 'Pharo'
]

{ #category : #'as yet unclassified' }
SWShellEnvironment class >> transpile_self: cdt [
	cdt
		methodBodyTranspilerOf: #localDirectory is: [ :mbt |
			mbt
				put: 'return FileLocator.localDirectory()';
				putStatementDelimiter;
				cr
		].

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
