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
