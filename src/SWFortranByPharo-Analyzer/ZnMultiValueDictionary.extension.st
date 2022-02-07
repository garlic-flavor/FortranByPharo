Extension { #name : #ZnMultiValueDictionary }

{ #category : #'*SWFortranByPharo-Analyzer' }
ZnMultiValueDictionary class >> initializeClassSideTranspiler: transpiler [
	transpiler
		declareMethod: #defaultLimit asReturn: SmallInteger

]

{ #category : #'*SWFortranByPharo-Analyzer' }
ZnMultiValueDictionary class >> initializeInstanceSideTranspiler: transpiler [
	transpiler
		declareMethodReturnsReceiver: #checkLimitForKey:
]
