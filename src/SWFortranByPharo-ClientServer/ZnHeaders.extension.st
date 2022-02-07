Extension { #name : #ZnHeaders }

{ #category : #'*SWFortranByPharo-ClientServer' }
ZnHeaders class >> initializeInstanceSideTranspiler: transpiler [
	transpiler
		declareMethod: #normalizeHeaderKey: asReturn: String;
		declareMethodReturnsSecondArgument: #at:put:
]
