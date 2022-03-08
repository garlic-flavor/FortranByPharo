Class {
	#name : #SWMethodBodyTranspilerTest,
	#superclass : #TestCase,
	#instVars : [
		'mbt'
	],
	#category : #'SWFortranByPharo-Transpiler-Tests-Common'
}

{ #category : #running }
SWMethodBodyTranspilerTest >> setUp [
	super setUp.
	mbt := SWMethodBodyTranspiler new
		expression: SWExpression new;
		yourself
	
	"Put here a common initialization logic for tests"
]

{ #category : #tests }
SWMethodBodyTranspilerTest >> testNewVariableName [
	self assert: (mbt newVariableName) equals: 't_0'.
	self assert: (mbt newVariableName) equals: 't_1'

]
