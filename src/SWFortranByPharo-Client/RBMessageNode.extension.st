Extension { #name : #RBMessageNode }

{ #category : #'*SWFortranByPharo-Client' }
RBMessageNode >> transpileUsing: transpiler [
	^ transpiler putMessage: self receiver call: self selector with: self arguments.
]
