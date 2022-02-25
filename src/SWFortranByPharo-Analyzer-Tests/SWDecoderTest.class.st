Class {
	#name : #SWDecoderTest,
	#superclass : #SWDecoderTestBase,
	#category : #'SWFortranByPharo-Analyzer-Tests-Analyzer'
}

{ #category : #tests }
SWDecoderTest >> test_0010_nop [
	self resultWith: {  } equals: SWTestProgram

]

{ #category : #tests }
SWDecoderTest >> test_0020_return_constnat [
	self resultWith: {} equals: SmallInteger
]

{ #category : #tests }
SWDecoderTest >> test_0030_has_arguments [
	self resultWith: { Float } equals: Float
]

{ #category : #tests }
SWDecoderTest >> test_0040_local_variables [
	self resultWith: { } equals: SmallInteger

]

{ #category : #tests }
SWDecoderTest >> test_0050_call_wellknown_message [
	self resultWith: { Float } equals: Float
]

{ #category : #tests }
SWDecoderTest >> test_0060_ifTrue_ifFalse [
	self resultWith: { Boolean } equals: SWTestProgram
]

{ #category : #tests }
SWDecoderTest >> test_0070_ifTrue_ifFalse_expression [
	self resultWith: { Boolean } equals: SmallInteger
]

{ #category : #tests }
SWDecoderTest >> test_0080_ifTrue_ifFalse_shortcircuit [
	self resultWith: { Boolean } equals: SmallInteger
]

{ #category : #tests }
SWDecoderTest >> test_0090_ifTrue_ifFalse [
	self resultWith: { Boolean } equals: SWTestProgram
]

{ #category : #tests }
SWDecoderTest >> test_0120_ifTrue [
	self resultWith: { Boolean } equals: SWTestProgram
]

{ #category : #tests }
SWDecoderTest >> test_0140_ifFalse [
	self resultWith: { Boolean } equals: SWTestProgram
]

{ #category : #tests }
SWDecoderTest >> test_0170_ifNotNil_ifNil_expression [
	self resultWith: { Boolean } equals: SmallInteger
]

{ #category : #tests }
SWDecoderTest >> test_0190_ifNil_ifNotNil [
	self resultWith: { Boolean } equals: SWTestProgram
]

{ #category : #tests }
SWDecoderTest >> test_0240_ifNotNil_shortcircuit [
	self resultWith: { UndefinedObject } equals: SmallInteger

]

{ #category : #tests }
SWDecoderTest >> test_0260_ifNil_expression [
	self resultWith: { UndefinedObject } equals: SmallInteger.

]

{ #category : #tests }
SWDecoderTest >> test_0260_ifNil_expression2 [
	self resultWith: { String } equals: String

]

{ #category : #tests }
SWDecoderTest >> test_0290_method_call [
	self resultWith: { } equals: SWStd class

]

{ #category : #tests }
SWDecoderTest >> test_0300_recursive_message_call [
	self resultWith: { SmallInteger } equals: SmallInteger

]

{ #category : #tests }
SWDecoderTest >> test_0310_new [
	self resultWith: { SmallInteger } equals: Set

]

{ #category : #tests }
SWDecoderTest >> test_0320_return_literal [
	self resultWith: {  } equals: Dictionary

]

{ #category : #tests }
SWDecoderTest >> test_0330_try_catch [
	self resultWith: {  } equals: SWTestProgram

]

{ #category : #tests }
SWDecoderTest >> test_0340_try_catch_expression [
	self resultWith: {  } equals: SmallInteger

]

{ #category : #tests }
SWDecoderTest >> test_0350_try_catch_shortcircuit [
	self resultWith: {  } equals: SmallInteger

]

{ #category : #tests }
SWDecoderTest >> test_0390_opBinaries [
	self resultWith: { Float } equals: Float

]

{ #category : #tests }
SWDecoderTest >> test_0400_cascading [
	self resultWith: { String } equals: String

]

{ #category : #tests }
SWDecoderTest >> test_0410_call_Transceipt [
	self resultWith: {  } equals: SWTestProgram

]

{ #category : #tests }
SWDecoderTest >> test_0420_closure_local_variable [
	self resultWith: { } equals: SWTestProgram

]

{ #category : #tests }
SWDecoderTest >> test_0430_ifTrue_and_local_variable [
	self resultWith: { } equals: SmallInteger

]

{ #category : #tests }
SWDecoderTest >> test_0440_locals [
	self resultWith: { String } equals: SmallInteger

]

{ #category : #tests }
SWDecoderTest >> test_0450_locals2 [
	self resultWith: { String } equals: SmallInteger

]

{ #category : #tests }
SWDecoderTest >> test_0460_access_to_instance_variable [
	self resultWith: {  } equals: SmallInteger

]

{ #category : #tests }
SWDecoderTest >> test_0470_user_specified_variable_type [
	self resultWith: {  } equals: Integer

]
