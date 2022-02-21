Extension { #name : #RBBlockNode }

{ #category : #'*SWFortranByPharo-Analyzer' }
RBBlockNode >> dispatchTo: transpiler [
	^ transpiler atClosure: self

]
