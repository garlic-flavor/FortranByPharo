Class {
	#name : #SWDecoderTest,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-Analyzer-Tests-Analyzer'
}

{ #category : #'as yet unclassified' }
SWDecoderTest >> decodeNo: no with: args [
	^ (SWDecoder new: (SWTestProgram getMy: no) sourceNode with: (args copyWithFirst: SWTestProgram))
		enableLogging;
		haltAt: #unresolvedSelector;
		decode;
		yourself
]

{ #category : #'as yet unclassified' }
SWDecoderTest >> resultOfNo: no with: args equals: type [
	|decoder|
	decoder := self decodeNo: no with: args.
	self assert: decoder methodResult value equals: type

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

{ #category : #tests }
SWDecoderTest >> test_05_ifTrue_ifFalse [
	self resultOfNo: 5 with: { Boolean } equals: SWTestProgram
]

{ #category : #tests }
SWDecoderTest >> test_06_ifTrue_ifFalse_expression [
	self resultOfNo: 6 with: { Boolean } equals: SmallInteger
]

{ #category : #tests }
SWDecoderTest >> test_07_ifTrue_ifFalse_shortcircuit [
	self resultOfNo: 7 with: { Boolean } equals: SmallInteger
]

{ #category : #tests }
SWDecoderTest >> test_08_ifTrue_ifFalse [
	self resultOfNo: 8 with: { Boolean } equals: SWTestProgram
]

{ #category : #tests }
SWDecoderTest >> test_11_ifTrue [
	self resultOfNo: 11 with: { Boolean } equals: SWTestProgram
]

{ #category : #tests }
SWDecoderTest >> test_13_ifFalse [
	self resultOfNo: 13 with: { Boolean } equals: SWTestProgram
]

{ #category : #tests }
SWDecoderTest >> test_16_ifNotNil_ifNil_expression [
	self resultOfNo: 16 with: { Boolean } equals: SmallInteger
]

{ #category : #tests }
SWDecoderTest >> test_18_ifNil_ifNotNil_expression [
	self resultOfNo: 18 with: { Boolean } equals: SWTestProgram
]

{ #category : #tests }
SWDecoderTest >> test_22_ifNil_expression [
	self resultOfNo: 22 with: { UndefinedObject } equals: SmallInteger.
	self resultOfNo: 22 with: { String } equals: String
]

{ #category : #tests }
SWDecoderTest >> test_27_ifNotNil_shortcircuit [
	self resultOfNo: 27 with: { UndefinedObject } equals: SmallInteger

]

{ #category : #tests }
SWDecoderTest >> test_28_method_call [
	self resultOfNo: 28 with: { } equals: SWStd class

]
