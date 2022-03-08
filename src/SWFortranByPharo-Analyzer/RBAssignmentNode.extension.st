Extension { #name : #RBAssignmentNode }

{ #category : #'*SWFortranByPharo-Analyzer' }
RBAssignmentNode >> dispatchTo: dispatcher [
	^ dispatcher atAssign: self
]
