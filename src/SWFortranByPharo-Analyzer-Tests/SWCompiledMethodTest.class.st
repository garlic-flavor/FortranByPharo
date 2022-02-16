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
	cc := SWCompiledMethod new: compiledMethod with: { SWTestProgram. Dictionary }
	"Put here a common initialization logic for tests"
]

{ #category : #tests }
SWCompiledMethodTest >> testArgNames [
	self assert: cc argNames equals: { 'arg1' }
]

{ #category : #tests }
SWCompiledMethodTest >> testArguments [
	self assert: cc arguments size equals: 1.
	self assert: cc arguments first equals: Dictionary.
]

{ #category : #tests }
SWCompiledMethodTest >> testAtOffset [
	self assert: (cc atOffset: 0) equals: Dictionary
]

{ #category : #tests }
SWCompiledMethodTest >> testDeclaringNames [
	self assert: cc declaringNames equals: { 'outer1' }
]

{ #category : #tests }
SWCompiledMethodTest >> testDeclarings [
	self assert: cc declarings size equals: 1.
	self assert: cc declarings first name equals: 'outer1'.
]

{ #category : #'as yet unclassified' }
SWCompiledMethodTest >> testGetVariableNameOfIfFoundIfNone [
	self assert: (cc getVariableNameOf: 'arg1' ifFound: [ :each | each ] ifNone: [ false ]) equals: Dictionary
]

{ #category : #tests }
SWCompiledMethodTest >> testIsDecodable [
	self assert: cc isDecodable
]

{ #category : #tests }
SWCompiledMethodTest >> testLocals [
	self assert: cc locals size equals: 4.
]

{ #category : #tests }
SWCompiledMethodTest >> testMethodClass [
	self assert: cc methodClass equals: SWTestProgram.
]

{ #category : #tests }
SWCompiledMethodTest >> testNewWith [
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

{ #category : #tests }
SWCompiledMethodTest >> testReceiver [
	self assert: cc receiver equals: SWTestProgram
]

{ #category : #tests }
SWCompiledMethodTest >> testReceiverClass [
	self assert: cc receiverClass equals: SWTestProgram
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
