Extension { #name : #RBBlockNode }

{ #category : #'*SWFortranByPharo-Analyzer' }
RBBlockNode >> traverseUsing: transpiler [
	^ transpiler putClosure: self

]
