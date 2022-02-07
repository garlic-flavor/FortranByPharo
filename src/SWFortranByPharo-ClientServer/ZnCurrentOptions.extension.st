Extension { #name : #ZnCurrentOptions }

{ #category : #'*SWFortranByPharo-ClientServer' }
ZnCurrentOptions class >> initializeClassSideTranspiler: transpiler [

	transpiler
		declareMethod: #at: asReturn: String
]
