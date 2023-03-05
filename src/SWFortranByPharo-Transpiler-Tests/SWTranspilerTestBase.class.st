Class {
	#name : #SWTranspilerTestBase,
	#superclass : #TestCase,
	#instVars : [
		'module'
	],
	#category : #'SWFortranByPharo-Transpiler-Tests-Common'
}

{ #category : #accessing }
SWTranspilerTestBase class >> moduleTranspilerClass [
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SWTranspilerTestBase >> _resultWith: arguments [
	self
		transpile: (SWTestProgram getBySelector: thisContext sender sender selector)
		with: (arguments copyWithFirst: SWTestProgram).
	^ module stream contents

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
	module := self class moduleTranspilerClass new.
	module stream newline: String cr
	"Put here a common initialization logic for tests"
]

{ #category : #utilities }
SWTranspilerTestBase >> transpile: aMethod with: operands [
	^ self subclassResponsibility 
]

{ #category : #utilities }
SWTranspilerTestBase >> transpileBody: aMethod with: operands [
	^ (module pool transpilerFor: aMethod with: operands)
		transpileAsMain

]

{ #category : #utilities }
SWTranspilerTestBase >> transpileModule: aMethod with: operands [
	^ (module method: aMethod with: operands)
		transpile

]
