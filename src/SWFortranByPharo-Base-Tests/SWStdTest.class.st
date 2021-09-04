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
SWStdTest class >> rb_requirements [
	^ {
		'Pharo.rb'.
		SWTestBase.
		SWStd.
		SWSession.
	}
]

{ #category : #running }
SWStdTest >> setUp [
	super setUp.
	std := SWStd new.
	self type: #rb.
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

{ #category : #'code generation - tests' }
SWStdTest >> testPut [
	(self
		type: #rb;
		runAsClient: true;
		usingPharoServer: true;
		source) inspect
]

{ #category : #'code generation - tests' }
SWStdTest >> testThis [
	self
		go.

]

{ #category : #'code generation - tests' }
SWStdTest >> testThisOnExternalServer [
	self
		goOnExternalServer.

]
