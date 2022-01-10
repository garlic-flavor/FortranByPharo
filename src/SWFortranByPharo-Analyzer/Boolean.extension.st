Extension { #name : #Boolean }

{ #category : #'*SWFortranByPharo-Analyzer' }
Boolean class >> initializeInstanceSideTranspiler: transpiler [
	transpiler
		defineMethodReturnsFirstOrSecondArgument: #ifTrue:ifFalse: with: [ :t :node | t putIfTrueIfFalse: node ];
		defineMethodReturnsFirstArgument: #ifTrue: with: [ :t :node | t putIfTrue: node ];
		defineMethod: #and: as: self;
		defineMethodReturnsFirstArgument: #ifFalse:

]
