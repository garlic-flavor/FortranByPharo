Extension { #name : #RBReturnNode }

{ #category : #'*SWFortranByPharo-Analyzer' }
RBReturnNode >> dispatchTo: dispatcher [
	^ dispatcher atReturn: self
		
]

{ #category : #'*SWFortranByPharo-Analyzer' }
RBReturnNode >> isExpression [
	^ true
]
