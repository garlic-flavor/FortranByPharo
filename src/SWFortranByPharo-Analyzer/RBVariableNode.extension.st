Extension { #name : #RBVariableNode }

{ #category : #'*SWFortranByPharo-Analyzer' }
RBVariableNode >> traverseUsing: transpiler [
	^ transpiler atVariable: self

]
