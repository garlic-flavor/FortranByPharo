Extension { #name : #FullBlockClosure }

{ #category : #'*SWFortranByPharo-Analyzer' }
FullBlockClosure >> dispatchTo: dispatcher [
	^ dispatcher atFullBlockClosure: self

]
