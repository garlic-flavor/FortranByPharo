Class {
	#name : #SWTestRunner,
	#superclass : #TestCase,
	#classInstVars : [
		'moduleTranspiler'
	],
	#category : #'SWFortranByPharo-ClientServer-Client'
}

{ #category : #building }
SWTestRunner class >> build [
	^ moduleTranspiler
		main: self;
		transpile;
		yourself

]

{ #category : #running }
SWTestRunner class >> go [
	|result|
	self newModuleTranspiler.
	self build.
	result := (self projectRunnerClass go: moduleTranspiler).
	(STON reader
		on: result message readStream;
		next) inspect
]

{ #category : #building }
SWTestRunner class >> inspectResult [
	(moduleTranspiler stream contents) inspect

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

{ #category : #'instance creation' }
SWTestRunner class >> newModuleTranspiler [
	^ moduleTranspiler := self moduleTranspilerClass new
]

{ #category : #'as yet unclassified' }
SWTestRunner class >> projectRunnerClass [
	^ self subclassResponsibility 
]

{ #category : #suites }
SWTestRunner class >> runAllTests [
	^ self buildSuiteFromSelectors run
]

{ #category : #initialization }
SWTestRunner class >> setUpTranspiler: mt [
	(mt global getClassInfo: TestAsserter)
		declareMethodReturnsReceiver: #assert:description:resumable:.

	self methodDict values select: [ :m | m protocol beginsWith: 'test' ] thenDo: [ :m |
		mt global decode: (SWSenderInfo new
			method: m;
			operands: { self };
			yourself).
	].

	(mt pool getClassInfo: TestCase class)
		methodBodyTranspilerOf: #allTestSelectors is: [ :mbt |
			mbt putReturnKeyword; put: ' '; putArrayHeader.
			(self methodDict values select: [ :m | m category beginsWith: 'test' ]) do: [ :each |
				mbt atString: each selector
			] separatedBy: [ mbt putArraySeparator ].
			mbt putArrayFooter; putStatementDelimiter; cr
		].

	(mt pool getClassInfo: SWTestRunner class)
		methodBodyTranspilerOf: #name is: [ :mbt |
			mbt putReturnKeyword; put: ' "'; put: self name; put: '"'; putStatementDelimiter; cr
		].


]

{ #category : #private }
SWTestRunner class >> solveDependencies: mt [
	mt global decode: #setUp with: { self }.
	mt global decode: #tearDown with: { self }.
	mt transpile: TestCase.
	mt transpile: SWTestRunner.
]

{ #category : #building }
SWTestRunner class >> tryBuild [
	self newModuleTranspiler.
	self build.
	self inspectResult.
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
