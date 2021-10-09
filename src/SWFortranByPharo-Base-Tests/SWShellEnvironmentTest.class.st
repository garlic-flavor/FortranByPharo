"
A SWShellEnvironmentTest is a test class for testing the behavior of SWShellEnvironment
"
Class {
	#name : #SWShellEnvironmentTest,
	#superclass : #SWTestBase,
	#category : #'SWFortranByPharo-Base-Tests'
}

{ #category : #'code generation' }
SWShellEnvironmentTest class >> mjs_requirements: transpiler [
	transpiler
		putImportNative: 'OSPlatform' from: 'Pharo.mjs';
		putImportClass: SWTestBase;
		putImportClass: SWShellEnvironment
]

{ #category : #accessing }
SWShellEnvironmentTest class >> rb_requirements [
	^ {
		SWTestBase.
		SWShellEnvironment
	}
]

{ #category : #test }
SWShellEnvironmentTest >> testExeFileExtension [
	OSPlatform current isMacOS ifTrue: [
		self assert: SWShellEnvironment default exeFileExtension equals: #out
	].
]

{ #category : #'code generation - running' }
SWShellEnvironmentTest >> testThis [
	self
		type: #mjs;
		runAsClient: true;
		usingPharoServer: true;
		ready;
		go.
]
