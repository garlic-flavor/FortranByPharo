Extension { #name : #ZnSingleThreadedServer }

{ #category : #'*SWFortranByPharo-Analyzer' }
ZnSingleThreadedServer class >> initializeInstanceSideTranspiler: aTranspiler [

	aTranspiler
		declareMethodReturnsReceiver: #stop:;
		declareMethodReturnsReceiver: #start
]
