Extension { #name : #Character }

{ #category : #'*SWFortranByPharo-Analyzer' }
Character class >> initializeClassSideTranspiler: transpiler [
	transpiler
		defineMethodReturnsReceiversInstance: #value:
]

{ #category : #'*SWFortranByPharo-Analyzer' }
Character class >> initializeInstanceSideTranspiler: transpiler [
	transpiler
		defineMethod: #asciiValue as: SmallInteger
]
