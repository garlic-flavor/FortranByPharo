"
A SWPRofJSTest is a test class for testing the behavior of SWPRofJS
"
Class {
	#name : #SWPRofJSTest,
	#superclass : #TestCase,
	#instVars : [
		'module',
		'runner'
	],
	#category : #'SWFortranByPharo-ClientServer-Tests'
}

{ #category : #tests }
SWPRofJSTest >> setUp [
	super setUp.
	module := SWMTofJS newFrom: SWTestProgram_01.
	runner := SWPRofJS new.

]

{ #category : #tests }
SWPRofJSTest >> testExecute [
	runner putAll.
	runner execute inspect.


]

{ #category : #tests }
SWPRofJSTest >> testPut [
	runner putAll.
	runner inspect.
]
