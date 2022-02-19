Class {
	#name : #SWDecoderTestOld,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-Analyzer-Tests-Olds'
}

{ #category : #'tests - source' }
SWDecoderTestOld >> _08_ZnServerClass_default [

	ZnServer startDefaultOn: 50000.
	^ ZnServer default
]

{ #category : #'as yet unclassified' }
SWDecoderTestOld >> _14_TestCase [
	^ TestCase selector: 'hoge'
]

{ #category : #'private - utility' }
SWDecoderTestOld >> decode: method receiver: receiver args: arg2 [
	|dec|

	dec := SWDecoderOld new: (SWCompiledMethodOld new: method receiver: receiver with: arg2).
	dec logger enabled: true.
	dec classInfo: (dec pool getClassTranspiler: method methodClass).
	dec decode.
	^ dec

]

{ #category : #'as yet unclassified' }
SWDecoderTestOld >> decodeNo: no withArguments: args [
	^ self decode: (SWTestProgram getMy: no) receiver: SWTestProgram args: args
]

{ #category : #'as yet unclassified' }
SWDecoderTestOld >> i_returnTypeOfNo: no withArguments: args equals: aType [
	|dec|
	dec := self decodeNo: no withArguments: args.
	self assert: dec code return value equals: aType.
	dec inspect
]

{ #category : #'as yet unclassified' }
SWDecoderTestOld >> inspectNo: no withArguments: args [
	(self decodeNo: no withArguments: args) inspect
]

{ #category : #'as yet unclassified' }
SWDecoderTestOld >> returnTypeOfNo: no withArguments: args equals: aType [
	|dec|
	dec := self decodeNo: no withArguments: args.
	self assert: dec code return value equals: aType
]

{ #category : #tests }
SWDecoderTestOld >> test_01_return_constant [

	self
		returnTypeOfNo: 1 withArguments: {  } equals: SmallInteger
]

{ #category : #tests }
SWDecoderTestOld >> test_02_call_wellknown_method [

	self
		returnTypeOfNo: 4 withArguments: { Integer } equals: Integer;
		returnTypeOfNo: 4 withArguments: { Float } equals: Float

]

{ #category : #tests }
SWDecoderTestOld >> test_03_jumpers [

	self
		returnTypeOfNo: 6 withArguments: { Boolean } equals: ByteString;
		returnTypeOfNo: 7 withArguments: { Boolean } equals: SmallInteger;
		returnTypeOfNo: 9 withArguments: { Boolean } equals: ByteString;
		returnTypeOfNo: 12 withArguments: { Boolean } equals: SmallInteger;
		returnTypeOfNo: 14 withArguments: { Boolean } equals: SmallInteger;
		returnTypeOfNo: 16 withArguments: { UndefinedObject } equals: ByteString;
		returnTypeOfNo: 20 withArguments: { UndefinedObject } equals: SmallInteger;
		returnTypeOfNo: 24 withArguments: { UndefinedObject } equals: SmallInteger;
		returnTypeOfNo: 26 withArguments: { UndefinedObject } equals: SmallInteger

]

{ #category : #tests }
SWDecoderTestOld >> test_04_recursive_messge_call [

	self returnTypeOfNo: 30 withArguments: { SmallInteger } equals: SmallInteger
]

{ #category : #tests }
SWDecoderTestOld >> test_05_local_variables [

	self returnTypeOfNo: 29 withArguments: {  } equals: SmallInteger
]

{ #category : #tests }
SWDecoderTestOld >> test_06_method_call [

	self returnTypeOfNo: 28 withArguments: {  } equals: SWStd class
]

{ #category : #tests }
SWDecoderTestOld >> test_07_decode_closure [
	self returnValueOf: [ 123 ] withArguments: { } equals: SmallInteger

]

{ #category : #tests }
SWDecoderTestOld >> test_08_ZnSerever_class_default [
	|sa|
	sa := SWDecoderOld new: self class>>#_08_ZnServerClass_default with: { self class }.
	sa pool addInitializerIn: SWServer.
"
	sa logger enabled: true.
"
	sa decode.
	self assert: sa return value equals: ZnManagingMultiThreadedServer 
]

{ #category : #tests }
SWDecoderTestOld >> test_09_access_to_instance_variables [
	|sa|
	sa := SWDecoderOld new: [|satp|
		satp := SWTestProgram new.
		satp var1: 999.
		satp var1
	].
	sa decode.
	self assert: sa return value equals: SmallInteger
]

{ #category : #tests }
SWDecoderTestOld >> test_10_new [
	self returnTypeOfNo: 31 withArguments: { Integer } equals: Set

]

{ #category : #tests }
SWDecoderTestOld >> test_11_ZnServer_startOn [
	|sa|
	sa := SWDecoderOld new: SWServer>>#startOn: with: { SWServer. SmallInteger }.
	sa pool addInitializerIn: SWServer.
"
	sa debugMode: true.
"
	sa decode.
	self assert: sa return value equals: SWServer.

]

{ #category : #tests }
SWDecoderTestOld >> test_12_try_catch [
	self returnTypeOfNo: 33 withArguments: {  } equals: SWTestProgram
]

{ #category : #tests }
SWDecoderTestOld >> test_13_return_literal [
	self returnTypeOfNo: 32 withArguments: {  } equals: Dictionary
]

{ #category : #tests }
SWDecoderTestOld >> test_14_TestCase_selector [
	self returnValueOfMy: #_14_TestCase withArguments: {  } equals: TestCase
]

{ #category : #tests }
SWDecoderTestOld >> test_15_SWShell_class_executeProcess [
	|dec|
	dec := SWDecoderOld new: SWShell class>>#executeProcess: with: { SWShell class. OSSUnixSubprocess }.
	dec pool addInitializerIn: SWShell.
"
	dec logger enabled: true.
"
	dec decode.
	self assert: dec return value equals: String
]

{ #category : #tests }
SWDecoderTestOld >> test_16_ensure [
	self returnTypeOfNo: 37 withArguments: {  } equals: SmallInteger
]

{ #category : #tests }
SWDecoderTestOld >> test_17_Transcript [
	self returnTypeOfNo: 39 withArguments: {  } equals: SWTestProgram
]

{ #category : #tests }
SWDecoderTestOld >> test_18_user_specified_type [
	self returnTypeOfNo: 40 withArguments: {  } equals: Integer

]

{ #category : #tests }
SWDecoderTestOld >> test_19_SWShellEnvironemt [
	|dec|
	dec := SWDecoderOld new: [ SWShellEnvironment default ] with: { self class }.
	dec logger enabled: true.
	dec decode.
	self assert: dec return value equals: SWShellEnvironment.
]

{ #category : #tests }
SWDecoderTestOld >> test_20_SWShellEnvironemtLocalDirectory [
	|dec|
	dec := SWDecoderOld new: [ SWShellEnvironment default localDirectory ] with: { self class }.
	dec logger enabled: true.
	dec decode.
	self assert: dec return value equals: FileLocator
]

{ #category : #tests }
SWDecoderTestOld >> test_21_ifTrue [
	|dec|
	dec := SWDecoderOld new: [ SWShellEnvironmentTest new testExeFileExtension ] with: { self class }.
	dec logger enabled: true.
	dec decode.
	self assert: dec return value equals: SWShellEnvironmentTest.
]

{ #category : #tests }
SWDecoderTestOld >> test_22_jumper2 [
	self returnValueOf: [
		|path|
		path := 123.
		path = 234 ifFalse: [ self error ].
		path
	] withArguments: { self class } equals: SmallInteger.

]

{ #category : #tests }
SWDecoderTestOld >> test_23_closure_local_variable [
	self inspectNo: 43 withArguments: {  }
]

{ #category : #tests }
SWDecoderTestOld >> test_24_closure [
	self i_returnTypeOfNo: 46 withArguments: { SmallInteger } equals: SmallInteger
]
