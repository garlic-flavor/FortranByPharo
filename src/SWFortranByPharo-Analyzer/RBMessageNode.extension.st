Extension { #name : #RBMessageNode }

{ #category : #'*SWFortranByPharo-Analyzer' }
RBMessageNode >> traverseUsing: transpiler [
	^ transpiler atMessage: self
]
