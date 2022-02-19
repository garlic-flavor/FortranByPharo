Extension { #name : #String }

{ #category : #'*SWFortranByPharo-Analyzer' }
String >> traverseUsing: transpiler [
	transpiler putString: self
]
