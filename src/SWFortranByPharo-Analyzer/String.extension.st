Extension { #name : #String }

{ #category : #'*SWFortranByPharo-Analyzer' }
String >> dispatchTo: dispatcher [
	^ dispatcher atString: self
]
