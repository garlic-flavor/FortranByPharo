Extension { #name : #RBAssignmentNode }

{ #category : #'*SWFortranByPharo-Analyzer' }
RBAssignmentNode >> dispatchTo: transpiler [
	^ transpiler atAssignTo: self variable with: self value
]
