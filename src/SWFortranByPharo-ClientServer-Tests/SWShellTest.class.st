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
SWShellTest class >> setupTranspiler: mt [
	SWShell setupTranspiler: mt.
	super setupTranspiler: mt

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
	super tryBuild

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

{ #category : #tests }
SWShellTest >> testPipe [
	|s|
	s := SWShell new
		| [ :io | io << 'hoge!'; done ];
		| [ :io |
			io stdin wait.
			io << 'hello, '; << io stdin upToEnd; << ' world!'; done
		];
		runAndWait.
	self assert: (String streamContents: [:st | st << s readStream upToEnd ]) equals:
		'hello, hoge! world!'.
	s close.
]
