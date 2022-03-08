Extension { #name : #Float }

{ #category : #'*SWFortranByPharo-Analyzer' }
Float >> dispatchTo: dispatcher [
	^ dispatcher atFloat: self
]
