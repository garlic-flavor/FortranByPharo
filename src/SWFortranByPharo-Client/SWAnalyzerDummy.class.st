"
I do nothing.
"
Class {
	#name : #SWAnalyzerDummy,
	#superclass : #Object,
	#category : #'SWFortranByPharo-Client-Analyzer'
}

{ #category : #'public API' }
SWAnalyzerDummy >> analyze: aClass s: aMethod with: argumentTypes [
]

{ #category : #'code generation' }
SWAnalyzerDummy >> putImportClass: aClass [
]

{ #category : #'code generation' }
SWAnalyzerDummy >> putVariable: aVariable [
	^ Smalltalk globals at: aVariable name
]

{ #category : #'public API' }
SWAnalyzerDummy >> subAnalyzer [
	^ self
]
