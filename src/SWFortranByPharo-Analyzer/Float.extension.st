Extension { #name : #Float }

{ #category : #'*SWFortranByPharo-Analyzer' }
Float >> dispatchTo: transpiler [
	^ transpiler putFloat: self
]
