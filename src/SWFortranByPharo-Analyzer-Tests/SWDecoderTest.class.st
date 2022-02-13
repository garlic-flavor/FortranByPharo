Class {
	#name : #SWDecoderTest,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-Analyzer-Tests-Analyzer'
}

{ #category : #'tests - source' }
SWDecoderTest >> _02_call_wellknown_message: arg1 [

	| tmp1 |
	tmp1 := 123.
	^ arg1 + tmp1
]

{ #category : #'tests - source' }
SWDecoderTest >> _03_ifTrue_ifFalse: arg1 [

	| tmp1 |
	^ arg1 = 5
		  ifTrue: [ 
			  tmp1 := 100.
			  tmp1 + 300 ]
		  ifFalse: [ 200 + 300 ]
]

{ #category : #'tests - source' }
SWDecoderTest >> _04_recursive_message_call: arg1 [

	^ 0 < arg1
		  ifTrue: [ arg1 + (self _04_recursive_message_call: arg1 - 1) ]
		  ifFalse: [ 0 ]
]

{ #category : #tests }
SWDecoderTest >> _05_local_variables [

	| tmp1 tmp2 tmp3 tmp4 tmp5 tmp6 tmp7 tmp8 tmp9 |

	^ tmp9 := 123
]

{ #category : #'tests - source' }
SWDecoderTest >> _06_method_call [
	^ SWStd print: 'hoge!'
]

{ #category : #'tests - source' }
SWDecoderTest >> _08_ZnServer [

	ZnServer startDefaultOn: 50000.
	^ ZnServer default
]

{ #category : #tests }
SWDecoderTest >> _10_new: arg1 [
	|loc1 loc2|
	loc1 := Dictionary new.
	loc2 := Set new.
	^ loc2
]

{ #category : #'as yet unclassified' }
SWDecoderTest >> _12_try_catch [

	[  
		Transcript show: 'hello'; cr
	] on: Exception do: [
		Transcript show: 'error!'
	]
]

{ #category : #'as yet unclassified' }
SWDecoderTest >> _13_return_literal [
	|dict url|
	dict := Dictionary new.
	dict at: 'fuga' put: (url ifNil: [ 'hoge' ]).
	^ dict
]

{ #category : #'as yet unclassified' }
SWDecoderTest >> _14_TestCase [
	^ TestCase selector: 'hoge'
]

{ #category : #'as yet unclassified' }
SWDecoderTest >> _15_test_ifNil [
	|val|
	^ val ifNil: [ val := 100 ]
]

{ #category : #'as yet unclassified' }
SWDecoderTest >> _17_test_ensure [
	^ [ 
		123 = 234 ifTrue: [ 
			123
		] ifFalse: [
			2.2362
		]
	] ensure: [ 'hoge' ]
]

{ #category : #'private - utility' }
SWDecoderTest >> decode: method withArguments: arg2 [
	|dec|
	dec := SWDecoder new: method with: ({method methodClass}, arg2).
	dec logger enabled: true.
	dec decode.
	^ dec

]

{ #category : #'as yet unclassified' }
SWDecoderTest >> decodeNo: no withArguments: args [
	^ self decode: (SWTestProgram getMy: no) withArguments: args
]

{ #category : #'private - utility' }
SWDecoderTest >> inspectMy: arg1 withArguments: arg2 [
	|dec|
	dec := SWDecoder new: self class>>arg1 with: ({self class}, arg2).
	dec logger enabled: true.
	dec decode; inspect

]

{ #category : #'as yet unclassified' }
SWDecoderTest >> inspectNo: no withArguments: args [
	(self decode: (SWTestProgram getMy: no) withArguments: args) inspect
]

{ #category : #'as yet unclassified' }
SWDecoderTest >> returnTypeOfNo: no withArguments: args equals: aType [
	|dec|
	dec := self decode: (SWTestProgram getMy: no) withArguments: args.
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
SWDecoderTest >> test_01 [

	self
		returnTypeOfNo: 1
		withArguments: {  }
		equals: SmallInteger
]

{ #category : #tests }
SWDecoderTest >> test_02 [

	self
		returnValueOfMy: #_02_call_wellknown_message:
		withArguments: { Integer }
		equals: Integer;
		returnValueOfMy: #_02_call_wellknown_message:
		withArguments: { Float }
		equals: Float
]

{ #category : #tests }
SWDecoderTest >> test_03 [

	self
		returnValueOfMy: #_03_ifTrue_ifFalse:
		withArguments: { Integer }
		equals: SmallInteger
]

{ #category : #tests }
SWDecoderTest >> test_04 [

	self
		returnValueOfMy: #_04_recursive_message_call:
		withArguments: { SmallInteger }
		equals: SmallInteger
]

{ #category : #tests }
SWDecoderTest >> test_05 [

	self
		returnValueOfMy: #_05_local_variables
		withArguments: {  }
		equals: SmallInteger
]

{ #category : #tests }
SWDecoderTest >> test_06 [

	self
		returnValueOfMy: #_06_method_call
		withArguments: {  }
		equals: SWStd class
]

{ #category : #tests }
SWDecoderTest >> test_07_decode_closure [
	self returnValueOf: [ 123 ] withArguments: { } equals: SmallInteger

]

{ #category : #tests }
SWDecoderTest >> test_08 [
	|sa|
	sa := SWDecoder new: self class>>#_08_ZnServer with: { self class }.
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
	self returnValueOfMy: #_10_new: withArguments: { Integer } equals: Set

]

{ #category : #tests }
SWDecoderTest >> test_11_ZnServer [
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
SWDecoderTest >> test_12 [
	self returnValueOfMy: #_12_try_catch withArguments: {  } equals: self class
]

{ #category : #tests }
SWDecoderTest >> test_13 [
	self returnValueOfMy: #_13_return_literal withArguments: {  } equals: Dictionary
]

{ #category : #tests }
SWDecoderTest >> test_14 [
	self returnValueOfMy: #_14_TestCase withArguments: {  } equals: TestCase
]

{ #category : #tests }
SWDecoderTest >> test_15 [
"
	self returnValueOfMy: #_15_test_ifNil withArguments: {  } equals: SmallInteger
"
	self returnValueOfMy: #_15_test_ifNil withArguments: {  } equals: SmallInteger

]

{ #category : #tests }
SWDecoderTest >> test_16 [
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
SWDecoderTest >> test_17 [
	self returnValueOfMy: #_17_test_ensure withArguments: {  } equals: SmallFloat64
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
SWDecoderTest >> test_jumper [
	self returnValueOf: [ false ifTrue: [ 123 ] ifFalse: [ 'false' ] ] withArguments: { self class } equals: ByteString.
	self returnValueOf: [ (1=2) ifTrue: [ 123 ] ifFalse: [ 'false' ] ] withArguments: { self class } equals: ByteString.
	self returnValueOf: [ false ifFalse: [ 123 ] ifTrue: [ 'false' ] ] withArguments: { self class } equals: ByteString.
	self returnValueOf: [ false ifTrue: [ 123 ] ] withArguments: { self class } equals: SmallInteger.
	self returnValueOf: [ (1=2) ifTrue: [ 123 ] ] withArguments: { self class } equals: SmallInteger.
	self returnValueOf: [ false ifFalse: [ 'false string' ] ] withArguments: { self class } equals: ByteString.
	self returnValueOf: [ |val | val ifNil: [ val := 123 ] ] withArguments: { self class } equals: SmallInteger.
	self returnValueOf: [ |val | val ifNotNil: [ val := 123 ] ] withArguments: { self class } equals: SmallInteger.
	self returnValueOf: [ |val | val ifNil: [ val := 123 ] ifNotNil: [ 'not nil' ] ] withArguments: { self class } equals: ByteString.
	self returnValueOf: [ |val | val ifNotNil: [ val := 123 ] ifNil: [ 'not nil' ] ] withArguments: { self class } equals: ByteString.

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
