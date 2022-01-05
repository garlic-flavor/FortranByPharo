Extension { #name : #Object }

{ #category : #'*SWFortranByPharo-Transpiler' }
Object >> transpileUsing: transpiler [
	^ transpiler put: self asString
]
