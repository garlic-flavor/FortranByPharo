Extension { #name : #ZnSingleThreadedServer }

{ #category : #'*SWFortranByPharo-Analyzer' }
ZnSingleThreadedServer class >> initializeInstanceSideTranspiler: aTranspiler [

	aTranspiler
		defineMethodReturnsReceiver: #stop:
]
