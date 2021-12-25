"
A SWClassTest is a test class for testing the behavior of SWClass
"
Class {
	#name : #SWClassTest,
	#superclass : #TestCase,
	#instVars : [
		'ci'
	],
	#category : #'SWFortranByPharo-Client-Tests-Analyzer'
}

{ #category : #running }
SWClassTest >> setUp [
	super setUp.
	
	ci := SWClass new
		targetClass: SWServer;
		transpilerClass: SWStackAnalyzer;
		yourself.

]

{ #category : #tests }
SWClassTest >> testClassSide [
	self assert: ci classSide equals: nil
]

{ #category : #tests }
SWClassTest >> testInstanceSide [
	self assert: ci instanceSide equals: ci
]
