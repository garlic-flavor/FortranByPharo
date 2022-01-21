Extension { #name : #Set }

{ #category : #'*SWFortranByPharo-Analyzer' }
Set class >> initializeInstanceSideTranspiler: transpiler [
	transpiler
		defineMethod: #includes: asReturn: Boolean
]
