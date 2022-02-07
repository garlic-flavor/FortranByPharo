Extension { #name : #Semaphore }

{ #category : #'*SWFortranByPharo-Analyzer' }
Semaphore class >> initializeInstanceSideTranspiler: transpiler [
	transpiler
		declareMethodReturnsReceiver: #signal;
		declareMethodReturnsReceiver: #wait
		
]
