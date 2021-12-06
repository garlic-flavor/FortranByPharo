Extension { #name : #RBAssignmentNode }

{ #category : #'*SWFortranByPharo-Client' }
RBAssignmentNode >> transpileUsing: arg1 [

	^ arg1 putAssignTo: self variable with: self value
]
