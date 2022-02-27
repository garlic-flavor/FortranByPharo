Class {
	#name : #SWTestRunner,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-ClientServer-Client'
}

{ #category : #building }
SWTestRunner class >> build [
	|mt|
	mt := self moduleTranspilerClass new.
"
	mt pool global haltAtUnresolvedSelector.
"
	mt main: self.
	^ mt


]

{ #category : #initialization }
SWTestRunner class >> decode_TestAsserter: ct [

	ct
		declareMethodReturnsReceiver: #assert:description:resumable:
]

{ #category : #'as yet unclassified' }
SWTestRunner class >> decode_self: ct [
	self methodDict values select: [ :m | m protocol beginsWith: 'test' ] thenDo: [ :m |
		ct getMessageInfo: (SWSenderInfo new
			method: m;
			operands: { self };
			yourself).
	]

]

{ #category : #running }
SWTestRunner class >> go [
	|module result|
	self halt; flag: #toRewrite.
	module := self build.
	result := (SWPRofJS go: module).
	(STON reader
		on: result message readStream;
		next) inspect
]

{ #category : #initialization }
SWTestRunner class >> initialize_TestSuite: transpiler [
	self halt; flag: #toRewirte.
	transpiler
		declareMethodReturnsReceiver: #run:
]

{ #category : #initialization }
SWTestRunner class >> initialize_selfClass: ct [
	self halt; flag: #toRewirte.
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

{ #category : #suites }
SWTestRunner class >> runAllTests [
	^ self buildSuiteFromSelectors run
]

{ #category : #'code generation' }
SWTestRunner class >> solveDependenciesUsing: transpiler [
	self halt; flag: #toRewirte.

	transpiler
		transpile: TestCase;
		transpile: SWTestRunner;
		decode: #setUp with: { self };
		decode: #tearDown with: { self }.
 	self methodDict select: [ :each | each selector beginsWith: 'test' ] thenDo: [ :each |
		transpiler decode: each selector with: { self }
	]


]

{ #category : #building }
SWTestRunner class >> tryBuild [
	|module result|
	module := self build.
	result := module stream contents.
	result inspect
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
