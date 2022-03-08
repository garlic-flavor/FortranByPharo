Extension { #name : #RBBlockNode }

{ #category : #'*SWFortranByPharo-Analyzer' }
RBBlockNode >> dispatchTo: dispatcher [
	^ dispatcher atBlock: self

]
