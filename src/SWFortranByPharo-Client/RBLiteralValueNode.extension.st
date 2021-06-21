Extension { #name : #RBLiteralValueNode }

{ #category : #'*SWFortranByPharo-Client' }
RBLiteralValueNode >> transpileUsing: transpiler [
	self flag: #TODO. "under construction"
	transpiler put: self sourceText.
]
