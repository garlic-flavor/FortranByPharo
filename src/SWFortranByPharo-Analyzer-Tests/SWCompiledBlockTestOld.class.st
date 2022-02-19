Class {
	#name : #SWCompiledBlockTestOld,
	#superclass : #TestCase,
	#instVars : [
		'compiledMethod',
		'compiledBlock',
		'cc'
	],
	#category : #'SWFortranByPharo-Analyzer-Tests-Olds'
}

{ #category : #running }
SWCompiledBlockTestOld >> setUp [
	super setUp.
	
	compiledMethod := SWTestProgram>>#_46_locals2:.
	cc := SWCompiledBlockDripperOld dripFrom: compiledMethod receiver: SWTestProgram args: { Dictionary }.
	compiledBlock := cc payload.
	"Put here a common initialization logic for tests"
]

{ #category : #tests }
SWCompiledBlockTestOld >> testArgNames [
	self assert: cc argNames equals: {  'arg2' }
]

{ #category : #tests }
SWCompiledBlockTestOld >> testAtOffset [
	self assert: (cc slot atOffset: 1) name equals: 'inner1'
]

{ #category : #tests }
SWCompiledBlockTestOld >> testDeclaringNames [
	self assertCollection: cc declaringNames hasSameElements: #(inner1)
]

{ #category : #tests }
SWCompiledBlockTestOld >> testGetVariableNameOfIfFoundIfNone [
	self assert: (cc getVariableNameOf: 'arg2' ifFound: [:each | true ] ifNone: [ false ])
]

{ #category : #tests }
SWCompiledBlockTestOld >> testInitialSize [
	self assert: cc initialSize equals: 4.
]

{ #category : #tests }
SWCompiledBlockTestOld >> testIsDecodable [
	self assert: cc isDecodable
]

{ #category : #tests }
SWCompiledBlockTestOld >> testMethodClass [
	self assert: cc methodClass equals: nil
]

{ #category : #tests }
SWCompiledBlockTestOld >> testNewReceiverArgs [
	self assert: cc class equals: SWCompiledBlockOld.
	self assert: cc payload class equals: CompiledBlock.
]

{ #category : #tests }
SWCompiledBlockTestOld >> testNumArgs [
	self assert: cc numArgs equals: 1
]

{ #category : #tests }
SWCompiledBlockTestOld >> testNumTemps [
	self assert: cc numTemps equals: 2.

]

{ #category : #accessing }
SWCompiledBlockTestOld >> testSelector [
	self assert: cc selector equals: 'closure'
]

{ #category : #tests }
SWCompiledBlockTestOld >> testSlot [
	self assert: cc slot size equals: 4.

]

{ #category : #tests }
SWCompiledBlockTestOld >> testSourceNode [
	self assert: cc sourceNode equals: compiledBlock sourceNode
]

{ #category : #tests }
SWCompiledBlockTestOld >> testTempNames [
	self assertCollection: cc tempNames hasSameElements: { 'arg2'. 'inner1' }
]
