Extension { #name : #RBCascadeNode }

{ #category : #'*SWFortranByPharo-Client' }
RBCascadeNode >> transpileUsing: transpiler [
	^ transpiler putCascade: self

]
