Extension { #name : #FullBlockClosure }

{ #category : #'*SWFortranByPharo-Client' }
FullBlockClosure >> transpileUsing: transpiler [
	^ self sourceNode transpileUsing: transpiler.

]
