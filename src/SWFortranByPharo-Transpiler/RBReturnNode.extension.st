Extension { #name : #RBReturnNode }

{ #category : #'*SWFortranByPharo-Transpiler' }
RBReturnNode >> transpileUsing: transpiler [
	^ transpiler putReturn: self value.
		
]
