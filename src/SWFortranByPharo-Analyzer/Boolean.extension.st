Extension { #name : #Boolean }

{ #category : #'*SWFortranByPharo-Analyzer' }
Boolean class >> initializeInstanceSideTranspiler: transpiler [
	transpiler
		defineMethodReturnsFirstOrSecondArgument: #ifTrue:ifFalse: as: [ :newT |
			newT
				senderGenerator: [ :t :node | t putIfTrueIfFalse: node ];
				yourself
		];
		defineMethodReturnsFirstArgument: #ifTrue: as: [ :newT |
			newT
				senderGenerator: [ :t :node | t putIfTrue: node ];
				yourself 
		];
		defineMethodReturnsFirstArgument: #ifFalse: as: [ :newT |
			newT
				senderGenerator: [ :t :node | t putIfFalse: node ];
				yourself
		];
		defineMethod: #and: asReturn: self;
		defineMethod: #or: asReturn: self

]
