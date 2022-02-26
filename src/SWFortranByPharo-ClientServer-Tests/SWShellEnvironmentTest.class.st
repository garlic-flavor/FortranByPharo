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
SWShellEnvironmentTest class >> solveDependenciesUsing: transpiler [
	super solveDependenciesUsing: transpiler.
	transpiler transpile: SWShellEnvironment

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
