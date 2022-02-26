Class {
	#name : #SWTranspilerTestBase,
	#superclass : #TestCase,
	#instVars : [
		'pool'
	],
	#category : #'SWFortranByPharo-Transpiler-Tests-Common'
}

{ #category : #'as yet unclassified' }
SWTranspilerTestBase class >> poolClass [
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SWTranspilerTestBase >> _resultWith: arguments [
	^ pool
		transpileBody: (SWTestProgram getBySelector: thisContext sender sender selector)
		with: (arguments copyWithFirst: SWTestProgram).

]

{ #category : #'as yet unclassified' }
SWTranspilerTestBase >> resultWith: arguments [
	|result|
	result := self _resultWith: arguments.
	result inspect.

]

{ #category : #'as yet unclassified' }
SWTranspilerTestBase >> resultWith: arguments equals: expected [
	|result|
	result := self _resultWith: arguments.
	self assert: result equals: expected
]

{ #category : #running }
SWTranspilerTestBase >> setUp [
	super setUp.
	pool := self class poolClass new.
	pool stream newline: String cr
	"Put here a common initialization logic for tests"
]
