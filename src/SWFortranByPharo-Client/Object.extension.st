Extension { #name : #Object }

{ #category : #'*SWFortranByPharo-Client' }
Object >> transpileUsing: transpiler [
	^ transpiler put: self asString
]
