Extension { #name : #RBLiteralArrayNode }

{ #category : #'*SWFortranByPharo-Transpiler' }
RBLiteralArrayNode >> transpileUsing: transpiler [
	^ self children transpileUsing: transpiler
]
