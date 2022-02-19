Class {
	#name : #SWDecoderTest,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-Analyzer-Tests-Analyzer'
}

{ #category : #'as yet unclassified' }
SWDecoderTest >> decodeNo: no with: args [
	^ (SWDecoder new: (SWTestProgram getMy: no) sourceNode with: (args copyWithFirst: SWTestProgram))
		decode;
		yourself
]

{ #category : #'as yet unclassified' }
SWDecoderTest >> resultOfNo: no with: args equals: type [
	self assert: (self decodeNo: no with: args) methodResult value equals: type

]

{ #category : #tests }
SWDecoderTest >> test_01_return_constnat [
	self resultOfNo: 1 with: {} equals: SmallInteger
]

{ #category : #tests }
SWDecoderTest >> test_02_has_arguments [
	self resultOfNo: 2 with: { Float } equals: Float
]

{ #category : #tests }
SWDecoderTest >> test_03_return_self [
	self resultOfNo: 3 with: {  } equals: SWTestProgram
]

{ #category : #tests }
SWDecoderTest >> test_04_call_wellknown_message [
	self resultOfNo: 4 with: { Float } equals: Float
]
