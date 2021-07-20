Extension { #name : #Integer }

{ #category : #'*SWFortranByPharo-Client' }
Integer >> transpileUsing: transpiler [
	transpiler put: self asString
]
