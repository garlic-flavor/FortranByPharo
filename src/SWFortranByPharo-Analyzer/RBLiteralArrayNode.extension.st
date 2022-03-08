Extension { #name : #RBLiteralArrayNode }

{ #category : #'*SWFortranByPharo-Analyzer' }
RBLiteralArrayNode >> dispatchTo: dispatcher [
	^ dispatcher atLiteralArray: self
]
