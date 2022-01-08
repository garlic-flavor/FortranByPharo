Extension { #name : #HashedCollection }

{ #category : #'*SWFortranByPharo-Analyzer' }
HashedCollection class >> initializeClassSideTranspiler: transpiler [
	transpiler
		defineMethodReturnsReceiversInstance: #new:
]
