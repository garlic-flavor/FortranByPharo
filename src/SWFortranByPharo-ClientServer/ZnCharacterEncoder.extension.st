Extension { #name : #ZnCharacterEncoder }

{ #category : #'*SWFortranByPharo-ClientServer' }
ZnCharacterEncoder class >> initializeClassSideTranspiler: transpiler [
	transpiler
		declareMethodReturnsReceiversInstance: #newForEncoding:
]

{ #category : #'*SWFortranByPharo-ClientServer' }
ZnCharacterEncoder class >> initializeInstanceSideTranspiler: transpiler [
	transpiler
		declareMethod: #encodeString: asReturn: ByteArray
]
