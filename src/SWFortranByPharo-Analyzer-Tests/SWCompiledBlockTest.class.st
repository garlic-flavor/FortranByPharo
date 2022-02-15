Class {
	#name : #SWCompiledBlockTest,
	#superclass : #TestCase,
	#instVars : [
		'compiledMethod',
		'compiledBlock',
		'cc'
	],
	#category : #'SWFortranByPharo-Analyzer-Tests-Analyzer'
}

{ #category : #running }
SWCompiledBlockTest >> setUp [
	super setUp.
	
	compiledMethod := SWTestProgram>>#_46_locals2:.
	compiledBlock := SWCompiledBlockDripper dripFrom: compiledMethod.
	cc := SWCompiledCode new: compiledBlock.
	"Put here a common initialization logic for tests"
]

{ #category : #tests }
SWCompiledBlockTest >> testNew [
	self assert: cc class equals: SWCompiledBlock
]
