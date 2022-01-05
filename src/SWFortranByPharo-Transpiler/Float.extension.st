Extension { #name : #Float }

{ #category : #'*SWFortranByPharo-Transpiler' }
Float >> transpileUsing: transpiler [
	^ transpiler putFloat: self
]
