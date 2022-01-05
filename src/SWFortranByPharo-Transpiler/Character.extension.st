Extension { #name : #Character }

{ #category : #'*SWFortranByPharo-Transpiler' }
Character >> transpileUsing: transpiler [
	^ transpiler putCharacter: self

]
