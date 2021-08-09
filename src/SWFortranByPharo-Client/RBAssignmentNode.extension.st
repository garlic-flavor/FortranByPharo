Extension { #name : #RBAssignmentNode }

{ #category : #'*SWFortranByPharo-Client' }
RBAssignmentNode >> transpileUsing: transpiler [
	^ transpiler assign: self variable with: self value
]
