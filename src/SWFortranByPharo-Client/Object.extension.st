Extension { #name : #Object }

{ #category : #'*SWFortranByPharo-Client' }
Object class >> initializeClassTranspiler: aCT [
	aCT targetClass isInstanceSide ifTrue: [
		aCT
			defineMethod: #subclassResponsibility as: [ :info | self error ]
	]
]

{ #category : #'*SWFortranByPharo-Client' }
Object >> transpileUsing: transpiler [
	^ transpiler put: self asString
]
