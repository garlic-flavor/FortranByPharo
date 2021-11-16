"
A SWStackAnalyzerTest is a test class for testing the behavior of SWStackAnalyzer
"
Class {
	#name : #SWStackAnalyzerTest,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-Client-Tests-Analyzer'
}

{ #category : #tests }
SWStackAnalyzerTest >> testSearchIn [
	self assert: (SWStackAnalyzer search: #= in: Integer) equals: Integer>>#=
]
