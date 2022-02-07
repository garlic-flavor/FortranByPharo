Extension { #name : #ProtoObject }

{ #category : #'*SWFortranByPharo-Analyzer' }
ProtoObject class >> initializeInstanceSideTranspiler: aCT [
	aCT
		declareMethodAsCompareOperator: #==;
		defineMethodReturnsReceiversClass: #class as: [ :newT |
			newT
				senderGenerator: [ :t :node |
					t << (RBVariableNode named: t receiverClass name)
				];
				yourself
		];
		setBreakpointOn: #primitiveFailed

]
