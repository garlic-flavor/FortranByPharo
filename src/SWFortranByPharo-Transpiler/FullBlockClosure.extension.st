Extension { #name : #FullBlockClosure }

{ #category : #'*SWFortranByPharo-Transpiler' }
FullBlockClosure >> transpileUsing: transpiler [
	^ self sourceNode transpileUsing: transpiler.

]
