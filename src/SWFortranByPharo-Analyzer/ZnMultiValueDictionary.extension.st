Extension { #name : #ZnMultiValueDictionary }

{ #category : #'*SWFortranByPharo-Analyzer' }
ZnMultiValueDictionary class >> initializeClassSideTranspiler: transpiler [
	transpiler
		defineMethod: #defaultLimit asReturn: SmallInteger

]

{ #category : #'*SWFortranByPharo-Analyzer' }
ZnMultiValueDictionary class >> initializeInstanceSideTranspiler: transpiler [
	transpiler
		defineMethodReturnsReceiver: #checkLimitForKey:
]
