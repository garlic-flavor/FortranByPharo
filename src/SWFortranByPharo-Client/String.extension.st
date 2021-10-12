Extension { #name : #String }

{ #category : #'*SWFortranByPharo-Client' }
String >> transpileUsing: transpiler [
	^ transpiler putString: self.
]
