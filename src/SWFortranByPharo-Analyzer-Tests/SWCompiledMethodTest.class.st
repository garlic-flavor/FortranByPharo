Class {
	#name : #SWCompiledMethodTest,
	#superclass : #TestCase,
	#instVars : [
		'compiledMethod',
		'cc'
	],
	#category : #'SWFortranByPharo-Analyzer-Tests-Analyzer'
}

{ #category : #running }
SWCompiledMethodTest >> setUp [
	super setUp.
	compiledMethod := SWTestProgram >>#_45_locals:.
	cc := SWCompiledCode new: compiledMethod
	"Put here a common initialization logic for tests"
]

{ #category : #tests }
SWCompiledMethodTest >> testArgNames [
	self assert: cc argNames equals: { 'arg1' }
]

{ #category : #tests }
SWCompiledMethodTest >> testCode [
	self assert: cc code equals: compiledMethod
]

{ #category : #tests }
SWCompiledMethodTest >> testDeclaringNames [
	self assert: cc declaringNames equals: { 'outer1' }
]

{ #category : #tests }
SWCompiledMethodTest >> testIsDecodable [
	self assert: cc isDecodable
]

{ #category : #tests }
SWCompiledMethodTest >> testNew [
	self assert: cc class equals: SWCompiledMethod
]

{ #category : #tests }
SWCompiledMethodTest >> testNumArgs [
	self assert: cc numArgs equals: 1
]

{ #category : #tests }
SWCompiledMethodTest >> testNumLocals [
	self assert: cc numLocals equals: 4.
]

{ #category : #tests }
SWCompiledMethodTest >> testNumTemps [
	self assert: cc numTemps equals: 2
]

{ #category : #accessing }
SWCompiledMethodTest >> testSelector [
	self assert: cc selector equals: compiledMethod selector
]

{ #category : #tests }
SWCompiledMethodTest >> testSourceNode [
	self assert: cc sourceNode equals: compiledMethod sourceNode
]

{ #category : #tests }
SWCompiledMethodTest >> testTempNames [
	self assert: cc tempNames equals: { 'arg1'. 'outer1' }
]
