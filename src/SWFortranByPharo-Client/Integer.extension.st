Extension { #name : #Integer }

{ #category : #'*SWFortranByPharo-Client' }
Integer >> transpileUsing: transpiler [
	^ transpiler putInteger: self
]
