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
	#classVars : [
		'default'
	],
	#category : #'SWFortranByPharo-Base-Shell'
}

{ #category : #accessing }
SWShellEnvironment class >> default [
	^ default ifNil: [ default := self newDefault ]

]

{ #category : #'code generation' }
SWShellEnvironment class >> mjs_localDirectoryUsing: transpiler [
	transpiler put: 'return new FileLocator(process.cwd());'
]

{ #category : #'code generation' }
SWShellEnvironment class >> mjs_requirements: transpiler [
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
