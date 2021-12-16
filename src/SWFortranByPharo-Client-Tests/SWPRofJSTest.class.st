"
A SWPRofJSTest is a test class for testing the behavior of SWPRofJS
"
Class {
	#name : #SWPRofJSTest,
	#superclass : #TestCase,
	#instVars : [
		'project',
		'runner'
	],
	#category : #'SWFortranByPharo-Client-Tests-Client'
}

{ #category : #tests }
SWPRofJSTest >> setUp [
	super setUp.
	project := SWPTofJS newFrom: SWTestProgram_01.
	runner := SWPRofJS newFrom: project.

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
