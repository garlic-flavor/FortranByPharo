Extension { #name : #RBReturnNode }

{ #category : #'*SWFortranByPharo-Client' }
RBReturnNode >> transpileUsing: transpiler [
	^ transpiler putReturn: self value.
		
]
