Extension { #name : #RBLiteralArrayNode }

{ #category : #'*SWFortranByPharo-Analyzer' }
RBLiteralArrayNode >> traverseUsing: transpiler [
	^ self children traverseUsing: transpiler
]
