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
	^ module
]

{ #category : #running }
SWTestRunner class >> go [
	|module result|
	module := self build.
	result := (SWPRofJS go: module).
	(STON reader
		on: result message readStream;
		next) inspect
]

{ #category : #accessing }
SWTestRunner class >> initializeClassSideTranspiler: transpiler [
	self halt; flag: #toRewrite.
	transpiler
		declareMethod: #name as: [ :newT |
			newT
				specifyReturnTypeAs: String;
				markAsDecoded;
				generator: [ :t |
					t putReturnThisClassName
				]
		]
]

{ #category : #accessing }
SWTestRunner class >> main [
	SWStd import: #(PharoObject TestAsserter TestSuite) from: 'Pharo'.
	self runAllTests

]

{ #category : #'as yet unclassified' }
SWTestRunner class >> moduleTranspilerClass [
	^ self subclassResponsibility
]

{ #category : #accessing }
SWTestRunner class >> name [
	^ super name
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
	transpiler
		transpile: TestCase;
		transpile: SWTestRunner;
		transpile: self
]
