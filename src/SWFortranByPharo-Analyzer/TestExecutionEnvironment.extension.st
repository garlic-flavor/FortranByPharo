Extension { #name : #TestExecutionEnvironment }

{ #category : #'*SWFortranByPharo-Analyzer' }
TestExecutionEnvironment class >> initializeInstanceSideTranspiler: transpiler [
	transpiler
		declareMethodReturnsReceiver: #watchDogLoop
]
