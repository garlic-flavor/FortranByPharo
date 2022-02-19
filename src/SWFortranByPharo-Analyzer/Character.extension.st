Extension { #name : #Character }

{ #category : #'*SWFortranByPharo-Analyzer' }
Character >> traverseUsing: transpiler [
	^ transpiler putCharacter: self

]
