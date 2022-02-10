Class {
	#name : #SWTestRunner,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-ClientServer-Client'
}

{ #category : #building }
SWTestRunner class >> build [
	|module|
	module := self newModuleTranspiler.
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

{ #category : #initialization }
SWTestRunner class >> initialize_TestAsserter: transpiler [
	transpiler
		declareMethodReturnsReceiver: #assert:description:resumable:
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

{ #category : #accessing }
SWTestRunner class >> moduleTranspilerClass [
	^ self subclassResponsibility
]

{ #category : #accessing }
SWTestRunner class >> name [
	^ super name
]

{ #category : #building }
SWTestRunner class >> newModuleTranspiler [
	|mt|
	mt := self moduleTranspilerClass newFrom: self.
	mt payload logger enabled: true.
	^ mt
		

]

{ #category : #suites }
SWTestRunner class >> runAllTests [
	^ self buildSuiteFromSelectors run
]

{ #category : #'code generation' }
SWTestRunner class >> solveDependenciesUsing: transpiler [
	transpiler
		transpile: TestCase;
		transpile: SWTestRunner;
		decode: #setUp with: { self };
		decode: #tearDown with: { self }.
 	self methodDict select: [ :each | each selector beginsWith: 'test' ] thenDo: [ :each |
		transpiler decode: each selector with: { self }
	]


]

{ #category : #running }
SWTestRunner >> setUp [
	super setUp.
	
	"Put here a common initialization logic for tests"
]

{ #category : #running }
SWTestRunner >> tearDown [
	super tearDown
]
