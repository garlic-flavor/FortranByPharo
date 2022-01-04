"
A SWClassTest is a test class for testing the behavior of SWClass
"
Class {
	#name : #SWClassTest,
	#superclass : #TestCase,
	#instVars : [
		'ci'
	],
	#category : #'SWFortranByPharo-Analyzer-Tests-Class'
}

{ #category : #running }
SWClassTest >> setUp [
	super setUp.
	
	ci := SWClass new
		targetClass: SWServer;
		yourself.

]
