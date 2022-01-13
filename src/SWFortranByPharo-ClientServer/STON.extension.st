Extension { #name : #STON }

{ #category : #'*SWFortranByPharo-ClientServer' }
STON class >> initializeClassSideTranspiler: transpiler [
	transpiler
		defineMethod: #jsonWriter as: STONWriter
]
