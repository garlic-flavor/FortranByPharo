"
A SWShellEnvironmentTest is a test class for testing the behavior of SWShellEnvironment
"
Class {
	#name : #SWShellEnvironmentTest,
	#superclass : #SWTestBase,
	#category : #'SWFortranByPharo-Server-Tests-Shell'
}

{ #category : #'code generation' }
SWShellEnvironmentTest class >> go [
	<sampleInstance>
	^ super go
]

{ #category : #accessing }
SWShellEnvironmentTest class >> rb_requirements [
	^ {
		SWTestBase.
		SWShellEnvironment
	}
]

{ #category : #'code generation' }
SWShellEnvironmentTest class >> transpile [
	<sampleInstance>
	^ super transpile
]

{ #category : #'code generation' }
SWShellEnvironmentTest class >> type [
	^ #rb
]

{ #category : #test }
SWShellEnvironmentTest >> testExeFileExtension [
	OSPlatform current isMacOS ifTrue: [
		self assert: SWShellEnvironment default exeFileExtension equals: #out
	].
]
