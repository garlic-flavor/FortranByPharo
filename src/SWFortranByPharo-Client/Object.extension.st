Extension { #name : #Object }

{ #category : #'*SWFortranByPharo-Client' }
Object class >> initializeInstanceSideTranspiler: aCT [
	aCT defineMethod: #subclassResponsibility as: [ :info | self error ]

]

{ #category : #'*SWFortranByPharo-Client' }
Object >> transpileUsing: transpiler [
	^ transpiler put: self asString
]
