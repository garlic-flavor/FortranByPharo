Extension { #name : #RBAssignmentNode }

{ #category : #'*SWFortranByPharo-Transpiler' }
RBAssignmentNode >> transpileUsing: transpiler [
	^ transpiler putAssignTo: self variable with: self value
]
