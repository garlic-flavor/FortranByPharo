Extension { #name : #ZnMimeType }

{ #category : #'*SWFortranByPharo-Analyzer' }
ZnMimeType class >> initializeInstanceSideTranspiler: transpiler [
	transpiler
		defineMethod: #isBinary asReturn: Boolean;
		defineMethodReturnsReceiver: #charSet:;
		defineMethodReturnsSecondArgument: #parameterAt:ifAbsent:
]
