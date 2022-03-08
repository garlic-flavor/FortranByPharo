Extension { #name : #RBVariableNode }

{ #category : #'*SWFortranByPharo-Analyzer' }
RBVariableNode >> dispatchTo: dispatcher [
	^ dispatcher atVariable: self

]
