"
A SWCompiledCodeTest is a test class for testing the behavior of SWCompiledCode
"
Class {
	#name : #SWDecodeBaseTest,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-Analyzer-Tests-Analyzer'
}

{ #category : #tests }
SWDecodeBaseTest >> test_01 [
	|cc|
	cc := SWDecoderBase new: (SWTestProgram getMy: 1)  with: { self class }.
	self assert: cc stack receiver value equals: self class.
	
	self assert: cc isDecoded not.
	cc markAsDecoded.
	self assert: cc isDecoded.
	self assert: cc methodClass equals: SWTestProgram.
	self assert: cc receiverClass equals: self class.
	self assert: cc return value equals: UndefinedObject.

]

{ #category : #tests }
SWDecodeBaseTest >> test_02 [
	|cc|

	cc := SWDecoderBase new: (SWTestProgram getMy: 2) with: { self class. String }.
	self assert: cc arguments size equals: 1.
	self assert: cc arguments first value equals: String.
	self assert: cc locals size equals: 0.
]
