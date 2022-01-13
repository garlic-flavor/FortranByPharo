Extension { #name : #Number }

{ #category : #'*SWFortranByPharo-Analyzer' }
Number class >> initializeInstanceSideTranspiler: transpiler [
	transpiler
		defineMethodAsBinaryOperator: #+

]
