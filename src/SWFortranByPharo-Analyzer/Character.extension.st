Extension { #name : #Character }

{ #category : #'*SWFortranByPharo-Analyzer' }
Character >> dispatchTo: transpiler [
	^ transpiler putCharacter: self

]
