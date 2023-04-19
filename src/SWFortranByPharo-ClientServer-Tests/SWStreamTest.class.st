"
A SWStreamTest is a test class for testing the behavior of SWStream
"
Class {
	#name : #SWStreamTest,
	#superclass : #TestCase,
	#instVars : [
		'q'
	],
	#category : #'SWFortranByPharo-ClientServer-Tests-Shell'
}

{ #category : #running }
SWStreamTest >> setUp [
	super setUp.
	q := SWStream new
	"Put here a common initialization logic for tests"
]

{ #category : #tests }
SWStreamTest >> testBasics [
	|msg|
	msg := 'hello, world'.
	q << msg; cr.
	self assert: q readLine equals: msg
]
