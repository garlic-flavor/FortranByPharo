Extension { #name : #RBMessageNode }

{ #category : #'*SWFortranByPharo-Client' }
RBMessageNode >> transpileUsing: transpiler [
	self flag: #TODO. "Under construction."
	transpiler putMessage: self receiver call: self selector with: self arguments.
]
