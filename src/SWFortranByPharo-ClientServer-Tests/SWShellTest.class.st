"
A SWShellTest is a test class for testing the behavior of SWShell
"
Class {
	#name : #SWShellTest,
	#superclass : #SWTestRunnerJS,
	#category : #'SWFortranByPharo-ClientServer-Tests-Shell'
}

{ #category : #running }
SWShellTest class >> go [
	<script>
	super go
]

{ #category : #'as yet unclassified' }
SWShellTest class >> setUpTranspiler: mt [
	SWShell setUpTranspiler: mt.
	super setUpTranspiler: mt

]

{ #category : #'as yet unclassified' }
SWShellTest class >> solveDependencies: mt [
	SWShell solveDependencies: mt.
	mt transpile: SWShell.
	super solveDependencies: mt.

]

{ #category : #building }
SWShellTest class >> tryBuild [
	<script>
	self newModuleTranspiler.

	self build.
	self inspectResult.

]

{ #category : #tests }
SWShellTest >> testExecution [
	"This test assumes that GFortran is on the path."
	|res|
	res := SWShell execute: 'gfortran' arguments: #('--version').
	self assert: [res beginsWith: 'GNU Fortran'].
]

{ #category : #tests }
SWShellTest >> testFilePathOf [

	self assert: (SWShell filePathOf: 'script') basename equals: 'script'
]
