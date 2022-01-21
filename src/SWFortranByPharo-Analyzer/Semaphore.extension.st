Extension { #name : #Semaphore }

{ #category : #'*SWFortranByPharo-Analyzer' }
Semaphore class >> initializeInstanceSideTranspiler: transpiler [
	transpiler
		defineMethodReturnsReceiver: #signal;
		defineMethodReturnsReceiver: #wait
		
]
