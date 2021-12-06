Extension { #name : #RBAssignmentNode }

{ #category : #'*SWFortranByPharo-Client' }
RBAssignmentNode >> transpileUsing: transpiler [
	^ transpiler putAssignTo: self variable with: self value
]
