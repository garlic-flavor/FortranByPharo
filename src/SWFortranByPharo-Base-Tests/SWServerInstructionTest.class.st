"
A SWServerInstructionTest is a test class for testing the behavior of SWServerInstruction
"
Class {
	#name : #SWServerInstructionTest,
	#superclass : #SWTestBase,
	#instVars : [
		'inst'
	],
	#category : #'SWFortranByPharo-Base-Tests'
}

{ #category : #'code generation' }
SWServerInstructionTest class >> classes [
	^ { SWServerInstruction }
]

{ #category : #'code generation' }
SWServerInstructionTest class >> go [
	<sampleInstance>
	^ super go
]

{ #category : #'code generation' }
SWServerInstructionTest class >> transpile [
	<sampleInstance>
	^ super transpile
]

{ #category : #'code generation' }
SWServerInstructionTest class >> type [
	^ #rb
]

{ #category : #running }
SWServerInstructionTest >> setUp [
	super setUp.
	inst := SWServerInstruction new.
	
]

{ #category : #tests }
SWServerInstructionTest >> testStonOn [
	|parsed|
	inst
		put;
		length: 10000.
	parsed := (SWServerInstruction fromSton: (STON reader on: (inst toString) readStream)).
	self assert: inst code equals: parsed code
]
