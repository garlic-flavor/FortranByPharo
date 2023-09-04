"
A SWFFFCallerTest is a test class for testing the behavior of SWFFFCaller
"
Class {
	#name : #SWFFFCallerTest,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-FFCaller-Tests'
}

{ #category : #tests }
SWFFFCallerTest >> test_0010_basics [
	self assert: (SWFFCaller new
		script: [ :arg1|
			SWType declare: #return as: Float.
			SWType declare: #arg1 as: Float.
			arg1 * 2.
		];
		referenceMode: false;
		call: 2.0) equals: 4.0

]
