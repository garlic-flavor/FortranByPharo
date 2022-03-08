Extension { #name : #RBPragmaNode }

{ #category : #'*SWFortranByPharo-Analyzer' }
RBPragmaNode >> dispatchTo: dispatcher [
	^ dispatcher atPragma: self
]
