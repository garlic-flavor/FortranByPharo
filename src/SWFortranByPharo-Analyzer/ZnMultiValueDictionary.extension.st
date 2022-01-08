Extension { #name : #ZnMultiValueDictionary }

{ #category : #'*SWFortranByPharo-Analyzer' }
ZnMultiValueDictionary class >> initializeClassSideTranspiler: transpiler [
	transpiler
		defineMethod: #defaultLimit as: SmallInteger

]

{ #category : #'*SWFortranByPharo-Analyzer' }
ZnMultiValueDictionary class >> initializeInstanceSideTranspiler: transpiler [
	transpiler
		defineMethodReturnsReceiver: #checkLimitForKey:
]
