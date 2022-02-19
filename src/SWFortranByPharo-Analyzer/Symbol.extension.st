Extension { #name : #Symbol }

{ #category : #'*SWFortranByPharo-Analyzer' }
Symbol >> traverseUsing: transpiler [
	^ transpiler putSymbol: self

]
