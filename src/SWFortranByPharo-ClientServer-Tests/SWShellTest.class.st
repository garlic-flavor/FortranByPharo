"
A SWShellTest is a test class for testing the behavior of SWShell
"
Class {
	#name : #SWShellTest,
	#superclass : #SWTestRunner,
	#category : #'SWFortranByPharo-ClientServer-Tests-Shell'
}

{ #category : #running }
SWShellTest class >> go [
	<script>
	super go
]

{ #category : #'as yet unclassified' }
SWShellTest class >> moduleTranspilerClass [
	^ SWMTofJS
]

{ #category : #'as yet unclassified' }
SWShellTest class >> solveDependenciesUsing: transpiler [
	super solveDependenciesUsing: transpiler.
	transpiler
		transpile: SWShell
]

{ #category : #building }
SWShellTest class >> tryBuild [
	<script>
	(self build: true) inspect
]

{ #category : #tests }
SWShellTest >> testExecution [
	"This test assumes that GFortran is on the path."
	|res|
	res := SWShell execute: 'gfortran' arguments: #('--version').
	self assert: [res beginsWith: 'GNU Fortran'].
]
