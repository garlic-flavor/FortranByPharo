"
A SWShellEnvironmentTest is a test class for testing the behavior of SWShellEnvironment
"
Class {
	#name : #SWShellEnvironmentTest,
	#superclass : #SWTestRunnerJS,
	#category : #'SWFortranByPharo-ClientServer-Tests-Shell'
}

{ #category : #running }
SWShellEnvironmentTest class >> go [
	<script>
	super go
]

{ #category : #initialization }
SWShellEnvironmentTest class >> setUpTranspiler: pool [
	SWShellEnvironment setUpTranspiler: pool.
	super setUpTranspiler: pool

]

{ #category : #private }
SWShellEnvironmentTest class >> solveDependencies: mt [
	SWShellEnvironment solveDependencies: mt.
	mt transpile: SWShellEnvironment.
	super solveDependencies: mt.

]

{ #category : #building }
SWShellEnvironmentTest class >> tryBuild [
	<script>
	super tryBuild
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
