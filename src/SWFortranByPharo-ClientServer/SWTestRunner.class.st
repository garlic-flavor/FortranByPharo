Class {
	#name : #SWTestRunner,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-ClientServer-Client'
}

{ #category : #adding }
SWTestRunner class >> addInitializerTo: pool [
	pool addInitializerIn: SWTestRunner.
]

{ #category : #building }
SWTestRunner class >> build: debugMode [
	|module|
	module := self moduleTranspilerClass newFrom: self.
	debugMode == true ifTrue: [ module enableDebugMode ].
	self addInitializerTo: module pool.
	module transpile.
	^ module
]

{ #category : #running }
SWTestRunner class >> go [
	|module result|
	module := self build: false.
	result := (SWPRofJS go: module).
	(STON reader
		on: result message readStream;
		next) inspect
]

{ #category : #initialization }
SWTestRunner class >> initialize_TestSuite: transpiler [
	transpiler
		declareMethodReturnsReceiver: #run:
]

{ #category : #initialization }
SWTestRunner class >> initialize_selfClass: ct [
	ct
		defineMethodBody: #name as: [ :t |
			t putReturnThisClassName
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
		transpiler decode: each selector with: (SWSlot newFrom: { self })
	].
	transpiler
		transpile: TestCase;
		transpile: SWTestRunner

]
