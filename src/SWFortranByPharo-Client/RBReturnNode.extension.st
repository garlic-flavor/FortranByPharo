Extension { #name : #RBReturnNode }

{ #category : #'*SWFortranByPharo-Client' }
RBReturnNode >> transpileUsing: transpiler [
	|ret|
	transpiler 	put: 'return '.
	ret := self value transpileUsing: transpiler.
	transpiler variables at: '%returnValue%' put: ret.
	^ ret
		
]
