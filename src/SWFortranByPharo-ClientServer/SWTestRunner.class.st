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
	self runAllTests

]

{ #category : #'as yet unclassified' }
SWTestRunner class >> moduleTranspilerClass [
	^ self subclassResponsibility
]

{ #category : #suites }
SWTestRunner class >> runAllTests [
	^ self buildSuiteFromSelectors run
]

{ #category : #'as yet unclassified' }
SWTestRunner class >> solveDependenciesUsing: transpiler [
 	self methodDict select: [ :each | each selector beginsWith: 'test' ] thenDo: [ :each |
		transpiler decode: each selector with: { self }
	].
	transpiler transpile: self
]
