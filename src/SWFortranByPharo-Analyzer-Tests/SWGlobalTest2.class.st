Class {
	#name : #SWGlobalTest2,
	#superclass : #SWGlobalTestBase,
	#category : #'SWFortranByPharo-Analyzer-Tests-Analyzer'
}

{ #category : #tests }
SWGlobalTest2 >> test_1010_SWShellEnvironment_default [
	self resultWith: { } equals: SWShellEnvironment
]

{ #category : #tests }
SWGlobalTest2 >> test_1020_SWShellEnvironment_localDirectory [
	self resultWith: { } equals: FileLocator
]

{ #category : #tests }
SWGlobalTest2 >> test_1030_SWShell_class_execute [

	self resultWith: { } equals: String
]

{ #category : #tests }
SWGlobalTest2 >> test_1040_TestCase [

	self resultWith: { } equals: TestCase
]

{ #category : #tests }
SWGlobalTest2 >> test_1050_ZnServerClass_default [
	self resultWith: { } equals: ZnManagingMultiThreadedServer 
]

{ #category : #tests }
SWGlobalTest2 >> test_1060_SWServerClass_starton [
	self resultWith: { } equals: SWServer
]
