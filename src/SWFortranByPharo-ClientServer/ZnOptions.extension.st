Extension { #name : #ZnOptions }

{ #category : #'*SWFortranByPharo-ClientServer' }
ZnOptions class >> initializeInstanceSideTranspiler: transpiler [
	transpiler
		defineMethod: #at as: ByteString
]
