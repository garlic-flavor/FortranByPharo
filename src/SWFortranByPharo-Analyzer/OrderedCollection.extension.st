Extension { #name : #OrderedCollection }

{ #category : #'*SWFortranByPharo-Analyzer' }
OrderedCollection class >> initializeInstanceSideTranspiler: transpiler [
	transpiler
		defineMethodReturnsFirstArgument: #do:;
		defineMethodReturnsFirstArgument: #reverseDo:
]
