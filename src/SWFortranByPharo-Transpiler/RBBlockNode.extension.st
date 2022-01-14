Extension { #name : #RBBlockNode }

{ #category : #'*SWFortranByPharo-Transpiler' }
RBBlockNode >> transpileUsing: transpiler [
	^ transpiler putClosure: self

]
