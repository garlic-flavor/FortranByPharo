Extension { #name : #RBSequenceNode }

{ #category : #'*SWFortranByPharo-Analyzer' }
RBSequenceNode >> dispatchTo: traverser [
	traverser atSequence: self
]
