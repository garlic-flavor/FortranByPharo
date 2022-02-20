Extension { #name : #FullBlockClosure }

{ #category : #'*SWFortranByPharo-Analyzer' }
FullBlockClosure >> dispatchTo: transpiler [
	^ self sourceNode dispatchTo: transpiler.

]
