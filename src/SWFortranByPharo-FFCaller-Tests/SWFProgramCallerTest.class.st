"
A SWFProgramCallerTest is a test class for testing the behavior of SWFProgramCaller
"
Class {
	#name : #SWFProgramCallerTest,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-FFCaller-Tests'
}

{ #category : #tests }
SWFProgramCallerTest >> test_0010_basics [
	|fpc|

	fpc := SWFProgramCaller new
		script: [ :io |
			io out << 'Hello, world!'
		];
		referenceMode: true;
		call;
		yourself.
	self assert: fpc io out contents equals: 'Hello, world!'.

]
