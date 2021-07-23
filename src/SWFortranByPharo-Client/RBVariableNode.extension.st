Extension { #name : #RBVariableNode }

{ #category : #'*SWFortranByPharo-Client' }
RBVariableNode >> transpileUsing: transpiler [
	^ transpiler put: self name

]
