Extension { #name : #ZnMimeType }

{ #category : #'*SWFortranByPharo-Analyzer' }
ZnMimeType class >> initializeInstanceSideTranspiler: transpiler [
	transpiler
		defineMethod: #isBinary as: Boolean
]
