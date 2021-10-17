Extension { #name : #Float }

{ #category : #'*SWFortranByPharo-Client' }
Float >> transpileUsing: transpiler [
	^ transpiler putFloat: self
]
