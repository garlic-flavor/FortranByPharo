Extension { #name : #Integer }

{ #category : #'*SWFortranByPharo-Analyzer' }
Integer >> dispatchTo: transpiler [
	^ transpiler atInteger: self
]
