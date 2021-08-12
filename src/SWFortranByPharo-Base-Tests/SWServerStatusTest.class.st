"
A SWServerStatusTest is a test class for testing the behavior of SWServerStatus
"
Class {
	#name : #SWServerStatusTest,
	#superclass : #SWTestBase,
	#instVars : [
		'status'
	],
	#category : #'SWFortranByPharo-Base-Tests'
}

{ #category : #'code generation' }
SWServerStatusTest class >> go [
	<sampleInstance>
	^ super go
]

{ #category : #'code generation' }
SWServerStatusTest class >> rb_requirements [
	^ {
		SWServerStatus.
		SWTestBase
	}
]

{ #category : #'code generation' }
SWServerStatusTest class >> transpile [
	<sampleInstance>
	^ super transpile
]

{ #category : #'code generation' }
SWServerStatusTest class >> type [
	^ #rb
]

{ #category : #running }
SWServerStatusTest >> setUp [
	super setUp.
	status := SWServerStatus new.
	"Put here a common initialization logic for tests"
]

{ #category : #tests }
SWServerStatusTest >> testStonOn [
	|status2|
	status ok;
		message: 'the requested method is not implemented.';
		toComplete: 100.
	status2 := SWServerStatus fromSton: (STON reader on: (status toString) readStream).
	self assert: [status2 isGood]
]
