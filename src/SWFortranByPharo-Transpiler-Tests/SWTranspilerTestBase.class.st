Class {
	#name : #SWTranspilerTestBase,
	#superclass : #TestCase,
	#instVars : [
		'decoder',
		'transpiler'
	],
	#category : #'SWFortranByPharo-Transpiler-Tests-Common'
}

{ #category : #'as yet unclassified' }
SWTranspilerTestBase >> getMethodBySelector: aSelector [
	^ SWTestProgram getBySelector: aSelector
]

{ #category : #'as yet unclassified' }
SWTranspilerTestBase >> makeArgument: arg [
	^ arg copyWithFirst: SWTestProgram
]

{ #category : #'as yet unclassified' }
SWTranspilerTestBase >> resultWith: arguments [
	|result|
	self transpile: thisContext sender selector with: arguments.
	result := transpiler stream contents.
	result inspect.

]

{ #category : #'as yet unclassified' }
SWTranspilerTestBase >> resultWith: arguments equals: expected [
	|result|
	self transpile: thisContext sender selector with: arguments.
	result := transpiler stream contents.
	self assert: result equals: expected
]

{ #category : #running }
SWTranspilerTestBase >> setUp [
	super setUp.
	decoder := SWMethodInfo new.
	transpiler := self transpilerClass new.
	"Put here a common initialization logic for tests"
]

{ #category : #initialization }
SWTranspilerTestBase >> setUpDecoder: selector with: args [
	decoder
		method: (self getMethodBySelector: selector);
		operands: (self makeArgument: args);
		decode.

]

{ #category : #utilities }
SWTranspilerTestBase >> transpile: selector with: arguments [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWTranspilerTestBase >> transpilerClass [
	^ self subclassResponsibility 
]
