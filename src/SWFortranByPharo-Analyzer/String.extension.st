Extension { #name : #String }

{ #category : #'*SWFortranByPharo-Analyzer' }
String >> dispatchTo: transpiler [
	transpiler atString: self
]
