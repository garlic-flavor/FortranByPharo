Extension { #name : #RBAssignmentNode }

{ #category : #'*SWFortranByPharo-Analyzer' }
RBAssignmentNode >> traverseUsing: transpiler [
	^ transpiler atAssignTo: self variable with: self value
]
