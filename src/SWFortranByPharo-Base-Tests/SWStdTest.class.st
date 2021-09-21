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
SWStdTest class >> mjs_requirements [
	^ {
		SWTestBase.
		SWStd.
	}
]

{ #category : #'code generation' }
SWStdTest class >> rb_requirements [
	^ {
		'Pharo.rb'.
		SWTestBase.
		SWStd.
	}
]

{ #category : #running }
SWStdTest >> setUp [
	self type: #mjs.
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

{ #category : #'code generation - tests' }
SWStdTest >> testThis [
	self
		type: #mjs;
		ready: self class name;
		runAsClient: true;
		usingPharoServer: true;
		go.

]

{ #category : #'code generation - tests' }
SWStdTest >> testThisOnExternalServer [
	self
		goOnExternalServer.

]
