Extension { #name : #RBBlockNode }

{ #category : #'*SWFortranByPharo-Client' }
RBBlockNode >> transpileUsing: transpiler [
	^ transpiler putBlock: self

]
