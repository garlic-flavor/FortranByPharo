"
A SWShellEnvironmentTest is a test class for testing the behavior of SWShellEnvironment
"
Class {
	#name : #SWShellEnvironmentTest,
	#superclass : #SWTestRunnerJS,
	#category : #'SWFortranByPharo-ClientServer-Tests-Shell'
}

{ #category : #'as yet unclassified' }
SWShellEnvironmentTest class >> decode_self: cdt [
	cdt pool getClassInfo: SWOS class.

]

{ #category : #running }
SWShellEnvironmentTest class >> go [
	<script>
	super go
]

{ #category : #initialization }
SWShellEnvironmentTest class >> setupTranspiler: pool [
	SWOS setupTranspiler: pool.
	super setupTranspiler: pool

]

{ #category : #private }
SWShellEnvironmentTest class >> solveDependencies: mt [
	SWOS solveDependencies: mt.
	mt transpile: SWOS.
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
		self assert: SWOS default exeFileExtension equals: #out
	].
]

{ #category : #tests }
SWShellEnvironmentTest >> testLocalDirectory [
	self assert: (SWOS default localDirectory fullName endsWith: 'FortranByPharo')
]
