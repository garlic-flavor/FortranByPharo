Extension { #name : #Boolean }

{ #category : #'*SWFortranByPharo-Analyzer' }
Boolean >> dispatchTo: dispatcher [
	dispatcher atBoolean: self
]
