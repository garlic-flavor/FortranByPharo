Extension { #name : #ProcessSpecificVariable }

{ #category : #'*SWFortranByPharo-Analyzer' }
ProcessSpecificVariable class >> initializeClassSideTranspiler: transpiler [
	transpiler
		defineMethodReturnsReceiversInstance: #new
]
