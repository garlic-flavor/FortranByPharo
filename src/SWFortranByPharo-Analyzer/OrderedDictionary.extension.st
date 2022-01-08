Extension { #name : #OrderedDictionary }

{ #category : #'*SWFortranByPharo-Analyzer' }
OrderedDictionary class >> initializeInstanceSideTranspiler: transpiler [
	transpiler
		defineMethodReturnsSecondArgument: #removeKey:ifAbsent:
]
