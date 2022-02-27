Class {
	#name : #SWClassInfoTest,
	#superclass : #TestCase,
	#instVars : [
		'global'
	],
	#category : #'SWFortranByPharo-Analyzer-Tests-Analyzer'
}

{ #category : #running }
SWClassInfoTest >> setUp [
	super setUp.
	global := SWGlobal new.
	"Put here a common initialization logic for tests"
]

{ #category : #tests }
SWClassInfoTest >> test_01 [
	global decode: (SWSenderInfo new
		method: SWShellEnvironmentTest>>#testLocalDirectory;
		operands: { SWShellEnvironmentTest  };
		yourself).
	global inspect.
]
