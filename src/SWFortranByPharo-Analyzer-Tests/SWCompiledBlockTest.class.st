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
	cc := SWCompiledBlockDripper dripFrom: compiledMethod with: {SWTestProgram. Dictionary }.
	compiledBlock := cc payload.
	"Put here a common initialization logic for tests"
]

{ #category : #tests }
SWCompiledBlockTest >> testArgNames [
	self assert: cc argNames equals: {  'arg2' }
]

{ #category : #tests }
SWCompiledBlockTest >> testDeclaringNames [
	self assertCollection: cc declaringNames hasSameElements: #(inner1)
]

{ #category : #tests }
SWCompiledBlockTest >> testIsDecodable [
	self assert: cc isDecodable
]

{ #category : #tests }
SWCompiledBlockTest >> testMethodClass [
	self assert: cc methodClass equals: nil
]

{ #category : #tests }
SWCompiledBlockTest >> testNew [
	self assert: cc class equals: SWCompiledBlock.
	self assert: cc payload class equals: CompiledBlock.
]

{ #category : #tests }
SWCompiledBlockTest >> testNumArgs [
	self assert: cc numArgs equals: 1
]
