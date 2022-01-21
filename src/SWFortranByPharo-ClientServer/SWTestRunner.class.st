Class {
	#name : #SWTestRunner,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-ClientServer-Client'
}

{ #category : #building }
SWTestRunner class >> build [
	|module|
	module := self moduleTranspilerClass newFrom: self.
	module enableDebugMode.
	module transpile.
	module inspect.
]

{ #category : #accessing }
SWTestRunner class >> main [
	^ self buildSuiteFromSelectors run
]

{ #category : #'as yet unclassified' }
SWTestRunner class >> moduleTranspilerClass [
	^ self subclassResponsibility
]
