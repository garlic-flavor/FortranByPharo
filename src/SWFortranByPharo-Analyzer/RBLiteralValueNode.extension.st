Extension { #name : #RBLiteralValueNode }

{ #category : #'*SWFortranByPharo-Analyzer' }
RBLiteralValueNode >> dispatchTo: dispatcher [
	^ dispatcher atLiteralValue: self

]
