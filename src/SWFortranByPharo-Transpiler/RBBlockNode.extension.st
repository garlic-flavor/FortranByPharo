Extension { #name : #RBBlockNode }

{ #category : #'*SWFortranByPharo-Transpiler' }
RBBlockNode >> transpileUsing: transpiler [
	^ transpiler putBlock: self

]
