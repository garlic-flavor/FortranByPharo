Extension { #name : #ZnCharacterEncoder }

{ #category : #'*SWFortranByPharo-ClientServer' }
ZnCharacterEncoder class >> initializeClassSideTranspiler: transpiler [
	transpiler
		defineMethodReturnsReceiversInstance: #newForEncoding:
]

{ #category : #'*SWFortranByPharo-ClientServer' }
ZnCharacterEncoder class >> initializeInstanceSideTranspiler: transpiler [
	transpiler
		defineMethod: #encodeString: asReturn: ByteArray
]
