"
A SWStdTest is a test class for testing the behavior of SWStd
"
Class {
	#name : #SWTest,
	#superclass : #SWTestBase,
	#category : #'SWFortranByPharo-ClientServer-Common-Tests'
}

{ #category : #'code generation' }
SWTest class >> mjs_requirements: transpiler [
	transpiler
		putImportClass: SWTestBase

]

{ #category : #'code generation' }
SWTest class >> rb_requirements [
	^ {
		'Pharo.rb'.
		SWTestBase.
		SWStd.
	}
]

{ #category : #running }
SWTest >> setUp [
	self type: #mjs.
	super setUp.
	
]

{ #category : #test }
SWTest >> testAssert [
	self mustFail: [self assert: [false]].
	self assert: [true].
]

{ #category : #test }
SWTest >> testError [
	self mustFail: [ self error: 'This is an error!' ]
]

{ #category : #'code generation - tests' }
SWTest >> testThis [
	self
		type: #mjs;
		runAsClient: true;
		usingPharoServer: true;
		ready;
		go.

]

{ #category : #'code generation - tests' }
SWTest >> testThisOnExternalServer [
	self
		type: #mjs;
		runAsClient: true;
		usingPharoServer: false;
		ready;
		go

]
