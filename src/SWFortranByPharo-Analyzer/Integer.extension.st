Extension { #name : #Integer }

{ #category : #'*SWFortranByPharo-Analyzer' }
Integer >> dispatchTo: dispatcher [
	^ dispatcher atInteger: self
]
