Extension { #name : #Integer }

{ #category : #'*SWFortranByPharo-Analyzer' }
Integer >> traverseUsing: transpiler [
	^ transpiler atInteger: self
]
