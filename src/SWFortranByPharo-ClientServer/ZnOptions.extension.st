Extension { #name : #ZnOptions }

{ #category : #'*SWFortranByPharo-ClientServer' }
ZnOptions class >> initializeInstanceSideTranspiler: transpiler [
	transpiler
		declareMethod: #at asReturn: ByteString
]
