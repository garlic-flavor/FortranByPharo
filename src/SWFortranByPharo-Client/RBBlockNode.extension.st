Extension { #name : #RBBlockNode }

{ #category : #'*SWFortranByPharo-Client' }
RBBlockNode >> transpileUsing: transpiler [
	^ self body transpileUsing: transpiler
]
