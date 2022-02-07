Extension { #name : #OrderedDictionary }

{ #category : #'*SWFortranByPharo-Analyzer' }
OrderedDictionary class >> initializeInstanceSideTranspiler: transpiler [
	transpiler
		declareMethodReturnsSecondArgument: #removeKey:ifAbsent:
]
