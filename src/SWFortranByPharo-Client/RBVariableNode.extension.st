Extension { #name : #RBVariableNode }

{ #category : #'*SWFortranByPharo-Client' }
RBVariableNode >> transpileUsing: transpiler [
	^ transpiler putVariable: (transpiler getVariable: self name) named: self name

]
