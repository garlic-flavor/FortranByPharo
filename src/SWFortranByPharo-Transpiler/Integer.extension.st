Extension { #name : #Integer }

{ #category : #'*SWFortranByPharo-Transpiler' }
Integer >> transpileUsing: transpiler [
	^ transpiler putInteger: self
]
