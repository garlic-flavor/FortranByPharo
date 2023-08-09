"
A SWIOTest is a test class for testing the behavior of SWIO
"
Class {
	#name : #SWIOTest,
	#superclass : #TestCase,
	#instVars : [
		'io',
		'done'
	],
	#category : #'SWFortranByPharo-ClientServer-Tests-Shell'
}

{ #category : #enumerating }
SWIOTest >> do: aScript [
	aScript value: io clone
]

{ #category : #running }
SWIOTest >> setUp [
	super setUp.

	done := Semaphore new.
	io := SWIO new
]

{ #category : #running }
SWIOTest >> tearDown [
	done terminateProcess.
	io close.
]

{ #category : #tests }
SWIOTest >> test_01_Basics [
	|msg read|
	msg := 'hello, world!'.
	io in nextPutAll: msg; ln.

	io in wait.
	read := io in readLn.
	io out nextPutAll: read; nextPutAll: read; flush.
	io out wait.
	self assert: io out readLn equals: msg, String lf.
	self assert: io out readLn equals: msg, String lf.
]
