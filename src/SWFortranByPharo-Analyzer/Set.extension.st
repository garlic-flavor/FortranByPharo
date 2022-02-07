Extension { #name : #Set }

{ #category : #'*SWFortranByPharo-Analyzer' }
Set class >> initializeInstanceSideTranspiler: transpiler [
	transpiler
		declareMethod: #includes: asReturn: Boolean
]
