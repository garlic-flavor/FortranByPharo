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
SWAnalyzerDummy >> putBlock: aBlock [
	^ Object
]

{ #category : #'code generation' }
SWAnalyzerDummy >> putCascade: aCascade [
	^ Object
]

{ #category : #'code generation' }
SWAnalyzerDummy >> putImportClass: aClass [
]

{ #category : #'code generation' }
SWAnalyzerDummy >> putInteger: anInteger [
	^ Object
]

{ #category : #'code generation' }
SWAnalyzerDummy >> putMessage: receiver call: selector with: arguments [
	^ Object
]

{ #category : #'code generation' }
SWAnalyzerDummy >> putString: aString [
	^ Object
]

{ #category : #'code generation' }
SWAnalyzerDummy >> putSymbol: aSymbol [
	^ Object
]

{ #category : #'code generation' }
SWAnalyzerDummy >> putVariable: aVariable [
	^ Smalltalk globals at: aVariable name ifAbsent: [ Object ]
]

{ #category : #'public API' }
SWAnalyzerDummy >> subAnalyzer [
	^ self
]
