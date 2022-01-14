Extension { #name : #Behavior }

{ #category : #'*SWFortranByPharo-Analyzer' }
Behavior class >> initializeInstanceSideTranspiler: transpiler [
	transpiler
		defineMethodReturnsReceiversInstance: #basicNew;
		defineMethodReturnsReceiversInstance: #basicNew:;
		defineMethod: #new with: [ :t :node | t putNew: node ]
]
