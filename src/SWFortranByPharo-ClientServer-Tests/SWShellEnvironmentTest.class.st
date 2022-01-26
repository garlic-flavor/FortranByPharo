"
A SWShellEnvironmentTest is a test class for testing the behavior of SWShellEnvironment
"
Class {
	#name : #SWShellEnvironmentTest,
	#superclass : #SWTestRunner,
	#category : #'SWFortranByPharo-ClientServer-Tests'
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
	transpiler transpile: SWShellEnvironment.
	transpiler payload
		putImport: #(OSPlatform) from: 'Pharo';
		putStatementDelimiter;
		cr.
	

]

{ #category : #building }
SWShellEnvironmentTest class >> tryBuild [
	<script>
	super build contents inspect
]

{ #category : #test }
SWShellEnvironmentTest >> testExeFileExtension [
	OSPlatform current isMacOS ifTrue: [
		self assert: SWShellEnvironment default exeFileExtension equals: #out
	].
]
