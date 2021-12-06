Extension { #name : #RBVariableNode }

{ #category : #'*SWFortranByPharo-Client' }
RBVariableNode >> transpileUsing: transpiler [
	^ transpiler putVariable: self

]
