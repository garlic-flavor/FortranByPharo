Extension { #name : #ZnMimeType }

{ #category : #'*SWFortranByPharo-Analyzer' }
ZnMimeType class >> initializeInstanceSideTranspiler: transpiler [
	transpiler
		declareMethod: #isBinary asReturn: Boolean;
		declareMethodReturnsReceiver: #charSet:;
		declareMethodReturnsSecondArgument: #parameterAt:ifAbsent:
]
