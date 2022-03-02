"
A SWShellEnvironmentTest is a test class for testing the behavior of SWShellEnvironment
"
Class {
	#name : #SWShellEnvironmentTest,
	#superclass : #SWTestRunner,
	#category : #'SWFortranByPharo-ClientServer-Tests-Shell'
}

{ #category : #running }
SWShellEnvironmentTest class >> go [
	<script>
	super go
]

{ #category : #'as yet unclassified' }
SWShellEnvironmentTest class >> moduleTranspilerClass [
	^ SWMTofJS
]

{ #category : #'as yet unclassified' }
SWShellEnvironmentTest class >> projectRunnerClass [
	^ SWPRofJS
]

{ #category : #initialization }
SWShellEnvironmentTest class >> setUpDecoder: global [
	self error; flag: #toRemove.
	SWShellEnvironment setUpDecoder: global.
	super setUpDecoder: global.

]

{ #category : #initialization }
SWShellEnvironmentTest class >> setUpTranspiler: pool [
	SWShellEnvironment setUpTranspiler: pool.
	super setUpTranspiler: pool.

]

{ #category : #private }
SWShellEnvironmentTest class >> solveDependencies: pool [
	pool transpile: SWShellEnvironment.
	super solveDependencies: pool.

]

{ #category : #'as yet unclassified' }
SWShellEnvironmentTest class >> solveDependenciesUsing: transpiler [
	self error; flag: #toRemove.
	super solveDependenciesUsing: transpiler.
	SWShellEnvironment solveDependenciesUsing: transpiler.
	transpiler transpile: SWShellEnvironment

]

{ #category : #building }
SWShellEnvironmentTest class >> tryBuild [
	<script>
	self newModuleTranspiler.
	self build.
	self inspectResult.
]

{ #category : #test }
SWShellEnvironmentTest >> testExeFileExtension [
	OSPlatform current isMacOS ifTrue: [
		self assert: SWShellEnvironment default exeFileExtension equals: #out
	].
]

{ #category : #tests }
SWShellEnvironmentTest >> testLocalDirectory [
	self assert: (SWShellEnvironment default localDirectory fullName endsWith: 'FortranByPharo')
]
