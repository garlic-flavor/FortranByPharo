Extension { #name : #TestAsserter }

{ #category : #'*SWFortranByPharo-Analyzer' }
TestAsserter class >> initializeInstanceSideTranspiler: transpiler [
	transpiler
		declareMethodReturnsReceiver: #assert:equals:
]
