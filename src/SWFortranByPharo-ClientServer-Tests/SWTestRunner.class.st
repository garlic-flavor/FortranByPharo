Class {
	#name : #SWTestRunner,
	#superclass : #TestCase,
	#classInstVars : [
		'moduleTranspiler'
	],
	#category : #'SWFortranByPharo-ClientServer-Tests-Common'
}

{ #category : #building }
SWTestRunner class >> build [
	^ moduleTranspiler
		main: self;
		transpile;
		yourself

]

{ #category : #initialization }
SWTestRunner class >> decode_self: cdt [
	(cdt pool getClassInfo: TestAsserter)
		declareMethodReturnsReceiver: #assert:description:resumable:.

	cdt pool decode: #setUp with: { self }.
	cdt pool decode: #tearDown with: { self }.

]

{ #category : #running }
SWTestRunner class >> go [
	|result|
	self newModuleTranspiler.
	self build.
	self inspectResult.
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
	SWStd_OLD import: #(PharoObject TestAsserter TestSuite) from: 'Pharo'.
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
SWTestRunner class >> setupTranspiler: mt [
	self methodDict values select: [ :m | m protocol beginsWith: 'test' ] thenDo: [ :m |
		mt global decode: (SWSenderInfo new
			method: m;
			operands: { self };
			yourself).
	].
	(mt pool getClassInfo: SWTestRunner class)
		methodBodyTranspilerOf: #name is: [ :mbt |
			mbt putReturnKeyword; put: ' "'; put: self name; put: '"'; putStatementDelimiter; cr
		].

	(mt pool getClassInfo: TestCase class)
		methodBodyTranspilerOf: #allTestSelectors is: [ :mbt |
			mbt putReturnKeyword; put: ' '; putArrayHeader.
			(self methodDict values select: [ :m | m category beginsWith: 'test' ]) do: [ :each |
				mbt atString: each selector
			] separatedBy: [ mbt putArraySeparator ].
			mbt putArrayFooter; putStatementDelimiter; cr
		].


]

{ #category : #private }
SWTestRunner class >> solveDependencies: mt [
	mt transpile: TestCase.
	mt transpile: SWTestRunner.
]

{ #category : #building }
SWTestRunner class >> tryBuild [
	self tryBuild: [  ]
]

{ #category : #building }
SWTestRunner class >> tryBuild: initializer [
	self newModuleTranspiler.
	initializer value.
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
