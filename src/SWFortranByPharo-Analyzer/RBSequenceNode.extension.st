Extension { #name : #RBSequenceNode }

{ #category : #'*SWFortranByPharo-Analyzer' }
RBSequenceNode >> traverseUsing: traverser [
	traverser atSequence: self
]
