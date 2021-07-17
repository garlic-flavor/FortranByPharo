Extension { #name : #RBArrayNode }

{ #category : #'*SWFortranByPharo-Client' }
RBArrayNode >> transpileUsing: transpiler [
	^ transpiler putArrayLiteral: self statements

]
