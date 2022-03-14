Extension { #name : #RBMethodNode }

{ #category : #'*SWFortranByPharo-Analyzer' }
RBMethodNode >> dispatchTo: traverser [
	traverser atMethod: self
]
