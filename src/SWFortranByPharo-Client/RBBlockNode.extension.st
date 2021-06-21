Extension { #name : #RBBlockNode }

{ #category : #'*SWFortranByPharo-Client' }
RBBlockNode >> transpileUsing: transpiler [
	self flag: #TODO. "under construction"
	self body transpileUsing: transpiler
]
