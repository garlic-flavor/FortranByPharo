Extension { #name : #String }

{ #category : #'*SWFortranByPharo-Transpiler' }
String >> transpileUsing: transpiler [
	transpiler putString: self
]
