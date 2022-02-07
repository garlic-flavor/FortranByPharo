Extension { #name : #STON }

{ #category : #'*SWFortranByPharo-ClientServer' }
STON class >> initializeClassSideTranspiler: transpiler [
	transpiler
		declareMethod: #jsonWriter asReturn: STONWriter
]
