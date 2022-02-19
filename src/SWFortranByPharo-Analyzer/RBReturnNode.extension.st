Extension { #name : #RBReturnNode }

{ #category : #'*SWFortranByPharo-Analyzer' }
RBReturnNode >> traverseUsing: transpiler [
	^ transpiler atReturn: self
		
]
