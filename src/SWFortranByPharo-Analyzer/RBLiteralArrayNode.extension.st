Extension { #name : #RBLiteralArrayNode }

{ #category : #'*SWFortranByPharo-Analyzer' }
RBLiteralArrayNode >> dispatchTo: transpiler [
	^ self children dispatchTo: transpiler
]
