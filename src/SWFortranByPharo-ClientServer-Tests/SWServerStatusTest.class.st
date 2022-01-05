"
A SWServerStatusTest is a test class for testing the behavior of SWServerStatus
"
Class {
	#name : #SWServerStatusTest,
	#superclass : #SWTestBase,
	#instVars : [
		'status'
	],
	#category : #'SWFortranByPharo-ClientServer-Tests'
}

{ #category : #'code generation' }
SWServerStatusTest class >> mjs_requirements: transpiler [
	transpiler
		putImportNative: 'Transcript' from: 'Pharo.mjs';
		putImportNative: 'STON' from: 'STON.mjs';
		putImportClass: SWServerStatus;
		putImportClass: SWTestBase

]

{ #category : #'code generation' }
SWServerStatusTest class >> rb_requirements [
	^ {
		SWServerStatus.
		SWTestBase
	}
]

{ #category : #running }
SWServerStatusTest >> setUp [
	super setUp.
	status := SWServerStatus new.
	self type: #rb.
	"Put here a common initialization logic for tests"
]

{ #category : #tests }
SWServerStatusTest >> testStonOn [
	|status2|
	status ok;
		message: 'the requested method is not implemented.';
		toComplete: 100.
	status2 := SWServerStatus fromSton: (STON reader on: (status toString) readStream).
	Transcript show: status2 toString.
	self assert: [status2 isGood]
]

{ #category : #'code generation - tests' }
SWServerStatusTest >> testThis [
	self
		type: #mjs;
		runAsClient: true;
		usingPharoServer: true;
		ready;
		go.
]

{ #category : #'code generation - tests' }
SWServerStatusTest >> testThisOnExternalServer [ 
	self
		type: #mjs;
		runAsClient: true;
		usingPharoServer: false;
		ready;
		go.
]
