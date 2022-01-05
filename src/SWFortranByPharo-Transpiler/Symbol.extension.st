Extension { #name : #Symbol }

{ #category : #'*SWFortranByPharo-Transpiler' }
Symbol >> transpileUsing: transpiler [
	^ transpiler putSymbol: self

]
