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

{ #category : #initialization }
SWTestRunner class >> decode_TestAsserter: ct [
	self error; flag: #toRemove.
	ct
		declareMethodReturnsReceiver: #assert:description:resumable:
]

{ #category : #'as yet unclassified' }
SWTestRunner class >> decode_receiver: ct [
	self error; flag: #toRemove.
	self methodDict values select: [ :m | m protocol beginsWith: 'test' ] thenDo: [ :m |
		ct pool decode: (SWSenderInfo new
			method: m;
			operands: { self };
			yourself).
	].
	ct pool decode: #setUp with: { self }.
	ct pool decode: #tearDown with: { self }.

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
SWTestRunner class >> setUpDecoder: global [
	self error; flag: #toRemove.
	(global getClassInfo: TestAsserter)
		declareMethodReturnsReceiver: #assert:description:resumable:.

	self methodDict values select: [ :m | m protocol beginsWith: 'test' ] thenDo: [ :m |
		global decode: (SWSenderInfo new
			method: m;
			operands: { self };
			yourself).
	].
	global decode: #setUp with: { self }.
	global decode: #tearDown with: { self }.

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
SWTestRunner class >> solveDependencies: pool [
	pool global decode: #setUp with: { self }.
	pool global decode: #tearDown with: { self }.
	pool transpile: TestCase.
]

{ #category : #'as yet unclassified' }
SWTestRunner class >> solveDependenciesUsing: pool [
	self error; flag: #toRemove.
	(pool global getClassInfo: TestAsserter)
		declareMethodReturnsReceiver: #assert:description:resumable:.

	self methodDict values select: [ :m | m protocol beginsWith: 'test' ] thenDo: [ :m |
		pool global decode: (SWSenderInfo new
			method: m;
			operands: { self };
			yourself).
	].
	pool global decode: #setUp with: { self }.
	pool global decode: #tearDown with: { self }.

"
	ctd
		methodBodyTranspilerOf: #allTestSelectors is: [ :mbt |
			mbt putReturnKeyword; put: ' '; putArrayHeader.
			(self methodDict values select: [ :m | m category beginsWith: 'test' ]) do: [ :each |
				mbt atString: each selector
			] separatedBy: [ mbt putArraySeparator ].
			mbt putArrayFooter; putStatementDelimiter; cr
		]
"
	pool transpile: TestCase.

	(pool getClassInfo: SWTestRunner class)
		methodBodyTranspilerOf: #name is: [ :mbt |
			mbt putReturnKeyword; put: ' "'; put: self name; put: '"'; putStatementDelimiter; cr
		].


]

{ #category : #'as yet unclassified' }
SWTestRunner class >> transpile_TestCaseClass: ctd [
	self error; flag: #toRemove.
	ctd
		methodBodyTranspilerOf: #allTestSelectors is: [ :mbt |
			mbt putReturnKeyword; put: ' '; putArrayHeader.
			(self methodDict values select: [ :m | m category beginsWith: 'test' ]) do: [ :each |
				mbt atString: each selector
			] separatedBy: [ mbt putArraySeparator ].
			mbt putArrayFooter; putStatementDelimiter; cr
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
