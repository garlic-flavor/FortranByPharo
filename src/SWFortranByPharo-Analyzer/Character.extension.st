Extension { #name : #Character }

{ #category : #'*SWFortranByPharo-Analyzer' }
Character class >> initializeClassSideTranspiler: transpiler [
	transpiler
		declareMethodReturnsReceiversInstance: #value:
]

{ #category : #'*SWFortranByPharo-Analyzer' }
Character class >> initializeInstanceSideTranspiler: transpiler [
	transpiler
		declareMethod: #asciiValue asReturn: SmallInteger

]
