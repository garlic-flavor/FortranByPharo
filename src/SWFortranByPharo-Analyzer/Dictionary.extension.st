Extension { #name : #Dictionary }

{ #category : #'*SWFortranByPharo-Analyzer' }
Dictionary class >> initializeInstanceSideTranspiler: transpiler [

	transpiler
		declareMethodReturnsSecondArgument: #at:put:;
		declareMethodReturnsSecondArgument: #at:ifAbsentPut:;
		declareMethod: #includesKey: asReturn: Boolean

]
