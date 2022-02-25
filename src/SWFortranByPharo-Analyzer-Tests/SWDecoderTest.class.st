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
		method: (SWTestProgram getMy: no);
		operands: (args copyWithFirst: SWTestProgram);
		decode;
		yourself
]

{ #category : #'as yet unclassified' }
SWDecoderTest >> noFromSelector: selector [
	^ ((selector copyAfter: $_) copyUpTo: $_) asInteger.

]

{ #category : #'as yet unclassified' }
SWDecoderTest >> resultWith: args [
	self decodeNo: (self noFromSelector: thisContext sender selector) with: args.
	self halt.
]

{ #category : #'as yet unclassified' }
SWDecoderTest >> resultWith: args equals: type [
	self decodeNo: (self noFromSelector: thisContext sender selector) with: args.
	self assert: decoder sender result value equals: type

]

{ #category : #running }
SWDecoderTest >> setUp [
	super setUp.
	decoder := SWDecoder new


]

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

{ #category : #tests }
SWDecoderTest >> test_48_SWShellEnvironment_default [
	self resultOfNo: 48 with: { } equals: SWShellEnvironment
]

{ #category : #tests }
SWDecoderTest >> test_49_SWShellEnvironment_localDirectory [
	self resultOfNo: 49 with: { } equals: FileLocator
]

{ #category : #tests }
SWDecoderTest >> test_50_SWShell_class_execute [
	decoder haltAtUnresolvedSelector: false.
	self resultOfNo: 50 with: { } equals: String
]

{ #category : #tests }
SWDecoderTest >> test_51_TestCase [

	self resultOfNo: 51 with: { } equals: TestCase
]

{ #category : #tests }
SWDecoderTest >> test_52_ZnServerClass_default [
	decoder haltAtUnresolvedSelector: false.
	self resultOfNo: 52 with: { } equals: ZnManagingMultiThreadedServer 
]

{ #category : #tests }
SWDecoderTest >> test_53_SWServerClass_starton [
	decoder haltAtUnresolvedSelector: false.
	self resultOfNo: 53 with: { } equals: SWServer
]
