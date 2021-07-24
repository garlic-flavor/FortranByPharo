Extension { #name : #RBBlockNode }

{ #category : #'*SWFortranByPharo-Client' }
RBBlockNode >> transpileUsing: transpiler [
	transpiler putLine: '(Proc.new do'.
	self body transpileUsing: transpiler.
	transpiler put: 'end)'.


]
