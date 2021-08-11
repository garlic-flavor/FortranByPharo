"
A SWShellTest is a test class for testing the behavior of SWShell
"
Class {
	#name : #SWShellTest,
	#superclass : #SWTestBase,
	#category : #'SWFortranByPharo-Server-Tests-Shell'
}

{ #category : #accessing }
SWShellTest class >> classes [
	^ { SWShell }
]

{ #category : #'code generation' }
SWShellTest class >> go [
	<sampleInstance>
	^ super go
]

{ #category : #'code generation' }
SWShellTest class >> transpile [
	<sampleInstance>
	^ super transpile
]

{ #category : #accessing }
SWShellTest class >> type [
	^ #rb
	
]

{ #category : #tests }
SWShellTest >> testExecution [
	"This test assumes that GFortran is on the path."
	|res|
	res := SWShell execute: 'gfortran' arguments: #('--version').
	self assert: (res beginsWith: 'GNU Fortran').
]
