Extension { #name : #ZnHeaders }

{ #category : #'*SWFortranByPharo-ClientServer' }
ZnHeaders class >> initializeInstanceSideTranspiler: transpiler [
	transpiler
		defineMethod: #normalizeHeaderKey: as: String;
		defineMethodReturnsSecondArgument: #at:put:
]
