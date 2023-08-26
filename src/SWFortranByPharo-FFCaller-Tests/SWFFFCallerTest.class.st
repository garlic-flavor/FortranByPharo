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
	|arg1|
	arg1 := 0.0.
	self assert: (SWFFCaller new
		script: [ :arg1|
			SWType declareReturnAs: #double.
			SWType declare: #arg1 as: #double.
			arg1 sin.
		];
		callWith: { 0.0 }) equals: 0.0

]
