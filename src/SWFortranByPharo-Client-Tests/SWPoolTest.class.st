"
A SWPoolTest is a test class for testing the behavior of SWPool
"
Class {
	#name : #SWPoolTest,
	#superclass : #TestCase,
	#instVars : [
		'pool'
	],
	#category : #'SWFortranByPharo-Client-Tests-Analyzer'
}

{ #category : #running }
SWPoolTest >> setUp [
	super setUp.
	
	pool := SWStackAnalyzer newDefaultPool
]

{ #category : #tests }
SWPoolTest >> testBasics [
	|mf|
	mf := SWMethodFinder new
		selector: #main;
		args: { SWServer class };
		yourself.
	pool new: mf.
	self error.
]
