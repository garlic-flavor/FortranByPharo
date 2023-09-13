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
			io ln: 'Hello, world!'
		];
		referenceMode: false;
		call;
		yourself.
	self assert: fpc io getStdoutAsString equals: (' Hello, world!', String lf).
	fpc close.
]
