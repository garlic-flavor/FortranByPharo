Extension { #name : #RBCascadeNode }

{ #category : #'*SWFortranByPharo-Analyzer' }
RBCascadeNode >> traverseUsing: transpiler [
	^ transpiler putCascade: self

]
