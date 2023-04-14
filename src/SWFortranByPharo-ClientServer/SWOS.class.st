"
This contains the information about development environment.
"
Class {
	#name : #SWOS,
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
SWOS class >> decode_self: cdt [
	cdt
		declareMethod: #localDirectory asReturn: FileLocator.
	(cdt pool getClassInfo: OSEnvironment class)
		declareMethodReturnsReceiversInstance: #environmentFor:.
	(cdt pool getClassInfo: OSPlatform class)
		declareMethodReturnsReceiversInstance: #current.
	(cdt pool getClassInfo: OSSUnixSubprocess)
		declareMethodReturnsReceiver: #run;
		declareMethodReturnsReceiver: #initialize.

]

{ #category : #accessing }
SWOS class >> default [
	^ default ifNil: [ default := self newDefault ]

]

{ #category : #'instance creation' }
SWOS class >> newDefault [
	OSPlatform current isMacOS ifTrue: [ 
		^ self newMacDefault
	].
	self error: 'This machine is not supported.'.

]

{ #category : #'instance creation' }
SWOS class >> newMacDefault [
	^ self new
		fortranCompilerAdapterClass: SWGFortranCompilerAdapter;
		exeFileExtension: #out;
		objFileExtension: #o;
		yourself.
]

{ #category : #initialization }
SWOS class >> resetDefault [
	<script>
	default := nil
]

{ #category : #initialization }
SWOS class >> setupTranspiler:  mt [
"
	(mt global getClassInfo: OSEnvironment class)
		declareMethodReturnsReceiversInstance: #environmentFor:.
	(mt global getClassInfo: OSPlatform class)
		declareMethodReturnsReceiversInstance: #current.
	(mt global getClassInfo: OSSUnixSubprocess)
		declareMethodReturnsReceiver: #run;
		declareMethodReturnsReceiver: #initialize.
"

]

{ #category : #private }
SWOS class >> solveDependencies: mt [
	mt
		transpile: SWGFortranCompilerAdapter;
		import: #(OSPlatform FileLocator) from: 'Pharo'
]

{ #category : #'as yet unclassified' }
SWOS class >> transpile_self: cdt [
	cdt
		methodBodyTranspilerOf: #localDirectory is: [ :mbt |
			mbt
				put: 'return FileLocator.localDirectory()';
				putStatementDelimiter;
				cr
		].

]

{ #category : #accessing }
SWOS >> exeFileExtension [

	^ exeFileExtension
]

{ #category : #accessing }
SWOS >> exeFileExtension: anObject [

	exeFileExtension := anObject
]

{ #category : #accessing }
SWOS >> fortranCompilerAdapterClass [

	^ fortranCompilerAdapterClass
]

{ #category : #accessing }
SWOS >> fortranCompilerAdapterClass: anObject [

	fortranCompilerAdapterClass := anObject
]

{ #category : #origins }
SWOS >> localDirectory [
	^ localDirectory ifNil: [
		localDirectory := ((IceRepository repositories detect: [ :each |
			each name = self packageName
		]) location)
	]
]

{ #category : #accessing }
SWOS >> objFileExtension [

	^ objFileExtension
]

{ #category : #accessing }
SWOS >> objFileExtension: anObject [

	objFileExtension := anObject
]

{ #category : #accessing }
SWOS >> packageName [

	^ packageName ifNil: [ packageName := 'FortranByPharo' ]
]

{ #category : #accessing }
SWOS >> packageName: anObject [

	packageName := anObject.
	localDirectory := nil
]
