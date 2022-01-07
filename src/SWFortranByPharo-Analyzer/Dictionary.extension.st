Extension { #name : #Dictionary }

{ #category : #'*SWFortranByPharo-Analyzer' }
Dictionary class >> initializeInstanceSideTranspiler: transpiler [

	transpiler
		defineMethodReturnsSecondArgument: #at:put:;
		defineMethodReturnsSecondArgument: #at:ifAbsentPut:;
		defineMethod: #includesKey: as: Boolean
]
