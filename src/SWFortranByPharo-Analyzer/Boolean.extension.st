Extension { #name : #Boolean }

{ #category : #'*SWFortranByPharo-Analyzer' }
Boolean class >> initializeInstanceSideTranspiler: transpiler [
	transpiler
		defineMethod: #ifTrue:ifFalse: with: [ :t :node | t putIfTrueIfFalse: node ];
		defineMethod: #ifTrue: with: [ :t :node | t putIfTrue: node ]
]
