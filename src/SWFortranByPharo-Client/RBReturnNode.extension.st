Extension { #name : #RBReturnNode }

{ #category : #'*SWFortranByPharo-Client' }
RBReturnNode >> transpileUsing: transpiler [
	transpiler 	put: 'return '.
	^ self value transpileUsing: transpiler
		
]
