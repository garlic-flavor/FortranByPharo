Extension { #name : #RBCascadeNode }

{ #category : #'*SWFortranByPharo-Transpiler' }
RBCascadeNode >> transpileUsing: transpiler [
	^ transpiler putCascade: self

]
