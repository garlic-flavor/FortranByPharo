Extension { #name : #RBVariableNode }

{ #category : #'*SWFortranByPharo-Transpiler' }
RBVariableNode >> transpileUsing: transpiler [
	^ transpiler putVariable: self

]
