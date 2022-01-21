Extension { #name : #Behavior }

{ #category : #'*SWFortranByPharo-Analyzer' }
Behavior class >> initializeInstanceSideTranspiler: transpiler [
	transpiler
		defineMethodReturnsReceiversInstance: #basicNew;
		defineMethodReturnsReceiversInstance: #basicNew:;
		defineMethod: #new as: [ :newT |
			newT
				senderGenerator: [ :t :node | t putNew: node ];
				yourself
		]
]
