Extension { #name : #RBReturnNode }

{ #category : #'*SWFortranByPharo-Analyzer' }
RBReturnNode >> dispatchTo: transpiler [
	^ transpiler atReturn: self
		
]

{ #category : #'*SWFortranByPharo-Analyzer' }
RBReturnNode >> isExpression [
	^ true
]
