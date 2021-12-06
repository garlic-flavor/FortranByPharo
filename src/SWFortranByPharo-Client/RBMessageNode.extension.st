Extension { #name : #RBMessageNode }

{ #category : #'*SWFortranByPharo-Client' }
RBMessageNode >> transpileUsing: transpiler [
	^ transpiler putMessage: self receiver send: self selector with: self arguments.
]
