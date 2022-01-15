"
A SWPoolTest is a test class for testing the behavior of SWPool
"
Class {
	#name : #SWPoolTest,
	#superclass : #TestCase,
	#instVars : [
		'pool'
	],
	#category : #'SWFortranByPharo-Analyzer-Tests-Analyzer'
}

{ #category : #running }
SWPoolTest >> setUp [
	super setUp.
	
	pool := SWStackAnalyzer newDefaultPool
]
