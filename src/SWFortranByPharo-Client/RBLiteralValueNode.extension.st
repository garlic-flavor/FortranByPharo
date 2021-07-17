Extension { #name : #RBLiteralValueNode }

{ #category : #'*SWFortranByPharo-Client' }
RBLiteralValueNode >> transpileUsing: transpiler [
	transpiler put: self sourceText.
	^ self value
]
