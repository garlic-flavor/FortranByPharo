Extension { #name : #RBMethodNode }

{ #category : #'*SWFortranByPharo-Client' }
RBMethodNode >> transpileUsing: transpiler [
	self flag: #TODO. "under construction."
	self body transpileUsing: transpiler.

]
