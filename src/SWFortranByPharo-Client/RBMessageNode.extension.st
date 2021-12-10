Extension { #name : #RBMessageNode }

{ #category : #'*SWFortranByPharo-Client' }
RBMessageNode >> transpileUsing: transpiler [
	^ transpiler putMessage: self.
]
