Extension { #name : #Float }

{ #category : #'*SWFortranByPharo-Analyzer' }
Float >> traverseUsing: transpiler [
	^ transpiler putFloat: self
]
