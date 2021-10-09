"
A SWShellTest is a test class for testing the behavior of SWShell
"
Class {
	#name : #SWShellTest,
	#superclass : #SWTestBase,
	#category : #'SWFortranByPharo-Base-Tests'
}

{ #category : #'code generation' }
SWShellTest class >> mjs_requirements: transpiler [
	transpiler
		putImportNative: 'FileLocator' from: 'Pharo.mjs';
		putImportClass: SWTestBase;
		putImportClass: SWShell
]

{ #category : #accessing }
SWShellTest class >> rb_requirements [
	^ {
		SWTestBase.
		SWShell
	}
]

{ #category : #tests }
SWShellTest >> testExecution [
	"This test assumes that GFortran is on the path."
	|res|
	res := SWShell execute: 'gfortran' arguments: #('--version').
	self assert: [res beginsWith: 'GNU Fortran'].
]

{ #category : #tests }
SWShellTest >> testLs [
	|dict|
	dict := SWShell ls: FileLocator imageDirectory.
	self assert: [(dict at: #children) anySatisfy: [ :each |
		(each at: #basename) = 'pharo-local'
	]]

]

{ #category : #'code generation - tests' }
SWShellTest >> testThis [
	self
		type: #mjs;
		runAsClient: true;
		usingPharoServer: true;
		ready;
		go.
]
