Extension { #name : #RBSequenceNode }

{ #category : #'*SWFortranByPharo-Analyzer' }
RBSequenceNode >> dispatchTo: traverser [
	traverser atSequence: self
]

{ #category : #'*SWFortranByPharo-Analyzer' }
RBSequenceNode >> isExpression [
	self containsReturn ifTrue: [ ^ false ].
	^ super isExpression
]
