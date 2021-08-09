"
I'm as test runner for SWStdTest class
"
Class {
	#name : #SWStdTestRunner,
	#superclass : #SWStd,
	#category : #'SWFortranByPharo-Base-Tests'
}

{ #category : #accessing }
SWStdTestRunner class >> declarationFilter: aSymbol [
	^ self declarationFilterBase: aSymbol
]

{ #category : #grammar }
SWStdTestRunner >> main: args [
	"I'm test runner for SWStd"
	|x|
	x := 5 * 5.
	self assert: [ x = 25 ].
	self print: x
]
