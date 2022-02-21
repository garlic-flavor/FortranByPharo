Class {
	#name : #SWDecoderTest,
	#superclass : #TestCase,
	#instVars : [
		'decoder'
	],
	#category : #'SWFortranByPharo-Analyzer-Tests-Analyzer'
}

{ #category : #'as yet unclassified' }
SWDecoderTest >> decodeNo: no with: args [
	^ decoder
		node: (SWTestProgram getMy: no) sourceNode;
		operands: (args copyWithFirst: SWTestProgram);
		enableLogging;
		haltAtUnresolvedSelector;
		decode;
		yourself
]

{ #category : #'as yet unclassified' }
SWDecoderTest >> resultOfNo: no with: args equals: type [
	|decoder|
	decoder := self decodeNo: no with: args.
	self assert: decoder methodResult value equals: type

]

{ #category : #running }
SWDecoderTest >> setUp [
	super setUp.
	decoder := SWDecoder new
	"Put here a common initialization logic for tests"
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

]

{ #category : #tests }
SWDecoderTest >> test_22_ifNil_expression2 [
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

{ #category : #tests }
SWDecoderTest >> test_29_local_variables [
	self resultOfNo: 29 with: { } equals: SmallInteger

]

{ #category : #tests }
SWDecoderTest >> test_30_recursive_message_call [
	self resultOfNo: 30 with: { SmallInteger } equals: SmallInteger

]

{ #category : #tests }
SWDecoderTest >> test_31_new [
	self resultOfNo: 31 with: { SmallInteger } equals: Set

]

{ #category : #tests }
SWDecoderTest >> test_32_return_literal [
	self resultOfNo: 32 with: {  } equals: Dictionary

]

{ #category : #tests }
SWDecoderTest >> test_33_try_catch [
	self resultOfNo: 33 with: {  } equals: SWTestProgram

]

{ #category : #tests }
SWDecoderTest >> test_34_try_catch_expression [
	self resultOfNo: 34 with: {  } equals: SmallInteger

]

{ #category : #tests }
SWDecoderTest >> test_37_try_catch_expression [
	self resultOfNo: 37 with: {  } equals: SmallInteger

]

{ #category : #tests }
SWDecoderTest >> test_38_try_catch_shortcircuit [
	self resultOfNo: 38 with: {  } equals: SmallInteger

]

{ #category : #tests }
SWDecoderTest >> test_39_call_Transceipt [
	self resultOfNo: 39 with: {  } equals: SWTestProgram

]

{ #category : #tests }
SWDecoderTest >> test_40_user_specified_variable_type [
	self resultOfNo: 40 with: {  } equals: Integer

]

{ #category : #tests }
SWDecoderTest >> test_41_cascading [
	self resultOfNo: 41 with: { String } equals: String

]

{ #category : #tests }
SWDecoderTest >> test_42_opBinaries [
	self resultOfNo: 42 with: { Float } equals: Float

]

{ #category : #tests }
SWDecoderTest >> test_43_closure_local_variable [
	self resultOfNo: 43 with: { } equals: SWTestProgram

]

{ #category : #tests }
SWDecoderTest >> test_44_ifTrue_and_local_variable [
	self resultOfNo: 44 with: { } equals: SmallInteger

]

{ #category : #tests }
SWDecoderTest >> test_45_locals [
	self resultOfNo: 45 with: { String } equals: SmallInteger

]

{ #category : #tests }
SWDecoderTest >> test_46_locals2 [
	self resultOfNo: 46 with: { String } equals: SmallInteger

]

{ #category : #tests }
SWDecoderTest >> test_47_access_to_instance_variable [
	self resultOfNo: 47 with: {  } equals: SmallInteger

]
