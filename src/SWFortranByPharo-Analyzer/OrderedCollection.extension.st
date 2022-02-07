Extension { #name : #OrderedCollection }

{ #category : #'*SWFortranByPharo-Analyzer' }
OrderedCollection class >> initializeInstanceSideTranspiler: transpiler [
	transpiler
		declareMethodReturnsFirstArgument: #do:;
		declareMethodReturnsFirstArgument: #reverseDo:
]
