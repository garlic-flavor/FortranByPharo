Extension { #name : #RBLiteralArrayNode }

{ #category : #'*SWFortranByPharo-Client' }
RBLiteralArrayNode >> transpileUsing: transpiler [
	^ self children transpileUsing: transpiler
]
