Extension { #name : #Behavior }

{ #category : #'*SWFortranByPharo-Analyzer' }
Behavior class >> initializeInstanceSideTranspiler: transpiler [
	transpiler
		declareMethodReturnsReceiversInstance: #basicNew;
		declareMethodReturnsReceiversInstance: #basicNew:;
		declareMethod: #new as: [ :newT |
			newT
				senderGenerator: [ :t :node | t putNew: node ];
				yourself
		]
]
