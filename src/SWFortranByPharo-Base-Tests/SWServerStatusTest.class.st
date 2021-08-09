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
		description: 'the requested method is not implemented.';
		toComplete: 100.
	status clear.
	status2 := SWServerStatus fromSton: (STON reader on: (status toString) readStream).
	status2 inspect
]
