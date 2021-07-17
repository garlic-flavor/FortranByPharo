Class {
	#name : #SWTranspilerTest,
	#superclass : #TestCase,
	#instVars : [
		'rbt'
	],
	#category : #'SWFortranByPharo-Client-Tests-Transpiler'
}

{ #category : #running }
SWTranspilerTest >> setUp [
	super setUp.
	rbt := SWTranspilerOfRuby new
		source: SWTestHelloWorld new;
		indentShifter: -1;
		yourself.
	"Put here a common initialization logic for tests"
]

{ #category : #accessing }
SWTranspilerTest >> source: anArray [
	^ rbt newline join: (anArray, {''}).
]

{ #category : #tests }
SWTranspilerTest >> test: aMethod equals: sourceLines [
	self assert: (rbt transpileMethod: aMethod; contents) equals: (self source: sourceLines)
]

{ #category : #test }
SWTranspilerTest >> testPutMessageCallWith [
	self test: #program equals: {'puts(''Hello, World!'')'}.
	rbt reset.
	self test: #program2 equals: {
	    ''.
		'a = 1 + 2'.
		'puts(a)'
	}.
]

{ #category : #tests }
SWTranspilerTest >> testSelectorNameOf [
	self assert: (SWTranspiler selectorNameOf: #print:) equals: 'print_'.
	self assert: (SWTranspiler selectorNameOf: #+) equals: 'opAdd'.
]

{ #category : #test }
SWTranspilerTest >> testTransformSelector [
	self assert: (rbt transformSelector: #print:) equals: 'rb_print_with:using:'.
	self assert: (rbt transformSelector: #+) equals: 'rb_opAdd_with:using:'
]
