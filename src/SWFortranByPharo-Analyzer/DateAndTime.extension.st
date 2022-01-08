Extension { #name : #DateAndTime }

{ #category : #'*SWFortranByPharo-Analyzer' }
DateAndTime class >> initializeClassSideTranspiler: transpiler [
	transpiler
		defineMethodReturnsReceiversInstance: #now
]
