Extension { #name : #RBMessageNode }

{ #category : #'*SWFortranByPharo-Analyzer' }
RBMessageNode >> dispatchTo: dispatcher [
	^ dispatcher atMessage: self
]
