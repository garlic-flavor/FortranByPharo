Class {
	#name : #SWDecoderTest2,
	#superclass : #SWDecoderTestBase,
	#category : #'SWFortranByPharo-Analyzer-Tests-Analyzer'
}

{ #category : #tests }
SWDecoderTest2 >> test_1010_SWShellEnvironment_default [
	self resultWith: { } equals: SWShellEnvironment
]

{ #category : #tests }
SWDecoderTest2 >> test_1020_SWShellEnvironment_localDirectory [
	self resultWith: { } equals: FileLocator
]

{ #category : #tests }
SWDecoderTest2 >> test_1030_SWShell_class_execute [
	decoder haltAtUnresolvedSelector: false.
	self resultWith: { } equals: String
]

{ #category : #tests }
SWDecoderTest2 >> test_1040_TestCase [

	self resultWith: { } equals: TestCase
]

{ #category : #tests }
SWDecoderTest2 >> test_1050_ZnServerClass_default [
	decoder haltAtUnresolvedSelector: false.
	self resultWith: { } equals: ZnManagingMultiThreadedServer 
]

{ #category : #tests }
SWDecoderTest2 >> test_1060_SWServerClass_starton [
	decoder haltAtUnresolvedSelector: false.
	self resultWith: { } equals: SWServer
]
