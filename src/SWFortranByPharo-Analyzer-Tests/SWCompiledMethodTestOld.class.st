Class {
	#name : #SWCompiledMethodTestOld,
	#superclass : #TestCase,
	#instVars : [
		'compiledMethod',
		'cc'
	],
	#category : #'SWFortranByPharo-Analyzer-Tests-Olds'
}

{ #category : #running }
SWCompiledMethodTestOld >> setUp [
	super setUp.
	compiledMethod := SWTestProgram >>#_0440_locals:.
	cc := SWCompiledMethodOld new: compiledMethod receiver: SWTestProgram with: { Dictionary }

]

{ #category : #tests }
SWCompiledMethodTestOld >> testArgNames [
	self assert: cc argNames equals: { 'arg1' }
]

{ #category : #tests }
SWCompiledMethodTestOld >> testArguments [
	self assert: cc arguments size equals: 1.
	self assert: cc arguments first equals: Dictionary.

]

{ #category : #tests }
SWCompiledMethodTestOld >> testAtOffset [
	self assert: (cc slot atOffset: 0) equals: Dictionary
]

{ #category : #tests }
SWCompiledMethodTestOld >> testDeclaringNames [
	self assert: cc declaringNames equals: { 'outer1' }
]

{ #category : #tests }
SWCompiledMethodTestOld >> testDeclarings [
	self assert: cc declarings size equals: 1.
	self assert: cc declarings first name equals: 'outer1'.
]

{ #category : #'as yet unclassified' }
SWCompiledMethodTestOld >> testGetVariableNameOfIfFoundIfNone [
	self assert: (cc getVariableNameOf: 'arg1' ifFound: [ :each | each ] ifNone: [ false ]) equals: Dictionary
]

{ #category : #tests }
SWCompiledMethodTestOld >> testInitialSize [
	self assert: cc initialSize equals: 4
]

{ #category : #tests }
SWCompiledMethodTestOld >> testIsDecodable [
	self assert: cc isDecodable
]

{ #category : #tests }
SWCompiledMethodTestOld >> testMethodClass [
	self assert: cc methodClass equals: SWTestProgram.
]

{ #category : #tests }
SWCompiledMethodTestOld >> testNewReceiverArgs [
	self assert: cc class equals: SWCompiledMethodOld.
	self assert: cc slot size equals: 4.
	self assert: cc slot first value equals: Dictionary.

]

{ #category : #tests }
SWCompiledMethodTestOld >> testNumArgs [
	self assert: cc numArgs equals: 1
]

{ #category : #tests }
SWCompiledMethodTestOld >> testNumTemps [
	self assert: cc numTemps equals: 2
]

{ #category : #tests }
SWCompiledMethodTestOld >> testReceiver [
	self assert: cc receiver equals: SWTestProgram
]

{ #category : #tests }
SWCompiledMethodTestOld >> testReceiverClass [
	self assert: cc receiverClass equals: SWTestProgram
]

{ #category : #accessing }
SWCompiledMethodTestOld >> testSelector [
	self assert: cc selector equals: compiledMethod selector
]

{ #category : #tests }
SWCompiledMethodTestOld >> testSourceNode [
	self assert: cc sourceNode equals: compiledMethod sourceNode
]

{ #category : #tests }
SWCompiledMethodTestOld >> testTempNames [
	self assert: cc tempNames equals: { 'arg1'. 'outer1' }
]
