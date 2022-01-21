Extension { #name : #ZnHeaders }

{ #category : #'*SWFortranByPharo-ClientServer' }
ZnHeaders class >> initializeInstanceSideTranspiler: transpiler [
	transpiler
		defineMethod: #normalizeHeaderKey: asReturn: String;
		defineMethodReturnsSecondArgument: #at:put:
]
