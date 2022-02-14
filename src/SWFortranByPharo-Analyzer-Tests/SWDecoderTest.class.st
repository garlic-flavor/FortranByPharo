Class {
	#name : #SWDecoderTest,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-Analyzer-Tests-Analyzer'
}

{ #category : #'tests - source' }
SWDecoderTest >> _08_ZnServerClass_default [

	ZnServer startDefaultOn: 50000.
	^ ZnServer default
]

{ #category : #'as yet unclassified' }
SWDecoderTest >> _14_TestCase [
	^ TestCase selector: 'hoge'
]

{ #category : #'private - utility' }
SWDecoderTest >> decode: method withArguments: arg2 [
	|dec|
	dec := SWDecoder new: method with: arg2.
	dec logger enabled: true.
	dec classInfo: (dec pool getClassTranspiler: method methodClass).
	dec decode.
	^ dec

]

{ #category : #'as yet unclassified' }
SWDecoderTest >> decodeNo: no withArguments: args [
	^ self decode: (SWTestProgram getMy: no) withArguments: ({SWTestProgram}, args)
]

{ #category : #'as yet unclassified' }
SWDecoderTest >> inspectNo: no withArguments: args [
	(self decode: (SWTestProgram getMy: no) withArguments: args) inspect
]

{ #category : #'as yet unclassified' }
SWDecoderTest >> returnTypeOfNo: no withArguments: args equals: aType [
	|dec|
	dec := self decodeNo: no withArguments: args.
	self assert: dec return value equals: aType
]

{ #category : #'private - utility' }
SWDecoderTest >> returnValueOf: arg1 withArguments: arg2 equals: arg3 [
	|analyzer|
	analyzer := SWDecoder new: arg1 with: arg2.
	analyzer logger enabled: true.
	analyzer decode.
	self
		assert: analyzer return value
		equals: arg3
]

{ #category : #'private - utility' }
SWDecoderTest >> returnValueOfMy: arg1 withArguments: arg2 equals: arg3 [

	self returnValueOf: self class>>arg1 withArguments: ({ self class }, arg2) equals: arg3

]

{ #category : #tests }
SWDecoderTest >> test_01_return_constant [

	self
		returnTypeOfNo: 1 withArguments: {  } equals: SmallInteger
]

{ #category : #tests }
SWDecoderTest >> test_02_call_wellknown_method [

	self
		returnTypeOfNo: 4 withArguments: { Integer } equals: Integer;
		returnTypeOfNo: 4 withArguments: { Float } equals: Float
]

{ #category : #tests }
SWDecoderTest >> test_03_jumpers [

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
SWDecoderTest >> test_04_recursive_messge_call [

	self returnTypeOfNo: 30 withArguments: { SmallInteger } equals: SmallInteger
]

{ #category : #tests }
SWDecoderTest >> test_05_local_variables [

	self returnTypeOfNo: 29 withArguments: {  } equals: SmallInteger
]

{ #category : #tests }
SWDecoderTest >> test_06_method_call [

	self returnTypeOfNo: 28 withArguments: {  } equals: SWStd class
]

{ #category : #tests }
SWDecoderTest >> test_07_decode_closure [
	self returnValueOf: [ 123 ] withArguments: { } equals: SmallInteger

]

{ #category : #tests }
SWDecoderTest >> test_08_ZnSerever_class_default [
	|sa|
	sa := SWDecoder new: self class>>#_08_ZnServerClass_default with: { self class }.
	sa pool addInitializerIn: SWServer.
"
	sa logger enabled: true.
"
	sa decode.
	self assert: sa return value equals: ZnManagingMultiThreadedServer 
]

{ #category : #tests }
SWDecoderTest >> test_09_access_to_instance_variables [
	|sa|
	sa := SWDecoder new: [|satp|
		satp := SWTestProgram new.
		satp var1: 999.
		satp var1
	].
	sa decode.
	self assert: sa return value equals: SmallInteger
]

{ #category : #tests }
SWDecoderTest >> test_10_new [
	self returnTypeOfNo: 31 withArguments: { Integer } equals: Set

]

{ #category : #tests }
SWDecoderTest >> test_11_ZnServer_startOn [
	|sa|
	sa := SWDecoder new: SWServer>>#startOn: with: { SWServer. SmallInteger }.
	sa pool addInitializerIn: SWServer.
"
	sa debugMode: true.
"
	sa decode.
	self assert: sa return value equals: SWServer.

]

{ #category : #tests }
SWDecoderTest >> test_12_try_catch [
	self returnTypeOfNo: 33 withArguments: {  } equals: SWTestProgram
]

{ #category : #tests }
SWDecoderTest >> test_13_return_literal [
	self returnTypeOfNo: 32 withArguments: {  } equals: Dictionary
]

{ #category : #tests }
SWDecoderTest >> test_14_TestCase_selector [
	self returnValueOfMy: #_14_TestCase withArguments: {  } equals: TestCase
]

{ #category : #tests }
SWDecoderTest >> test_15_SWShell_class_executeProcess [
	|dec|
	dec := SWDecoder new: SWShell class>>#executeProcess: with: { SWShell class. OSSUnixSubprocess }.
	dec pool addInitializerIn: SWShell.
"
	dec logger enabled: true.
"
	dec decode.
	self assert: dec return value equals: String
]

{ #category : #tests }
SWDecoderTest >> test_16_ensure [
	self returnTypeOfNo: 37 withArguments: {  } equals: SmallInteger
]

{ #category : #tests }
SWDecoderTest >> test_17_Transcript [
	self returnTypeOfNo: 39 withArguments: {  } equals: SWTestProgram
]

{ #category : #tests }
SWDecoderTest >> test_18_user_specified_type [
	self returnTypeOfNo: 40 withArguments: {  } equals: Integer

]

{ #category : #tests }
SWDecoderTest >> test_SWShellEnvironemt [
	|dec|
	dec := SWDecoder new: [ SWShellEnvironment default ] with: { self class }.
	dec logger enabled: true.
	dec decode.
	self assert: dec return value equals: SWShellEnvironment.
]

{ #category : #tests }
SWDecoderTest >> test_SWShellEnvironemtLocalDirectory [
	|dec|
	dec := SWDecoder new: [ SWShellEnvironment default localDirectory ] with: { self class }.
	dec logger enabled: true.
	dec decode.
	self assert: dec return value equals: FileLocator
]

{ #category : #tests }
SWDecoderTest >> test_ifTrue [
	|dec|
	dec := SWDecoder new: [ SWShellEnvironmentTest new testExeFileExtension ] with: { self class }.
	dec logger enabled: true.
	dec decode.
	self assert: dec return value equals: SWShellEnvironmentTest.
]

{ #category : #tests }
SWDecoderTest >> test_jumper2 [
	self returnValueOf: [
		|path|
		path := 123.
		path = 234 ifFalse: [ self error ].
		path
	] withArguments: { self class } equals: SmallInteger.

]
