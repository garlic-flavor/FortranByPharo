Extension { #name : #RBVariableNode }

{ #category : #'*SWFortranByPharo-Analyzer' }
RBVariableNode >> dispatchTo: transpiler [
	^ transpiler atVariable: self

]
