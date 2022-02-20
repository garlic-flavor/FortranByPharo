Extension { #name : #RBMessageNode }

{ #category : #'*SWFortranByPharo-Analyzer' }
RBMessageNode >> dispatchTo: transpiler [
	^ transpiler atMessage: self
]
