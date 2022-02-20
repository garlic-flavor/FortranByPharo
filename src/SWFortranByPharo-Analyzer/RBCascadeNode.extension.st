Extension { #name : #RBCascadeNode }

{ #category : #'*SWFortranByPharo-Analyzer' }
RBCascadeNode >> dispatchTo: transpiler [
	^ transpiler putCascade: self

]
