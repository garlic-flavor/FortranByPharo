Extension { #name : #Float }

{ #category : #'*SWFortranByPharo-Analyzer' }
Float >> dispatchTo: transpiler [
	^ transpiler atFloat: self
]
