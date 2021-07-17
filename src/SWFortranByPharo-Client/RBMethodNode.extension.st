Extension { #name : #RBMethodNode }

{ #category : #'*SWFortranByPharo-Client' }
RBMethodNode >> transpileUsing: transpiler [
	^ self body transpileUsing: transpiler.

]
