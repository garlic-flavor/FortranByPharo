Extension { #name : #RBArrayNode }

{ #category : #'*SWFortranByPharo-Analyzer' }
RBArrayNode >> dispatchTo: dispatcher [
	^ dispatcher atArray: self

]
