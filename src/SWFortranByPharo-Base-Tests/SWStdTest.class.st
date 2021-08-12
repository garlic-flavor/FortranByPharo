"
A SWStdTest is a test class for testing the behavior of SWStd
"
Class {
	#name : #SWStdTest,
	#superclass : #SWTestBase,
	#instVars : [
		'std'
	],
	#category : #'SWFortranByPharo-Base-Tests'
}

{ #category : #'code generation' }
SWStdTest class >> go [
	<sampleInstance>
	^ super go
]

{ #category : #'code generation' }
SWStdTest class >> rb_requirements [
	^ {
		'Pharo.rb'.
		SWTestBase.
		SWStd.
	}
]

{ #category : #'code generation' }
SWStdTest class >> transpile [
	<sampleInstance>
	^ super transpile
]

{ #category : #'code generation' }
SWStdTest class >> type [
	^ #rb
]

{ #category : #running }
SWStdTest >> setUp [
	super setUp.
	std := SWStd new.
]

{ #category : #test }
SWStdTest >> testAssert [
	self mustFail: [std assert: false].
	std assert: [true].
]

{ #category : #test }
SWStdTest >> testError [
	self mustFail: [ std error: 'This is an error!' ]
]
