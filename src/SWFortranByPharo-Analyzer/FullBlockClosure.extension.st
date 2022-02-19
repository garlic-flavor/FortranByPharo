Extension { #name : #FullBlockClosure }

{ #category : #'*SWFortranByPharo-Analyzer' }
FullBlockClosure >> traverseUsing: transpiler [
	^ self sourceNode traverseUsing: transpiler.

]
