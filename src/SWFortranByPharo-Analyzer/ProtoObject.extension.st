Extension { #name : #ProtoObject }

{ #category : #'*SWFortranByPharo-Analyzer' }
ProtoObject class >> initializeInstanceSideTranspiler: aCT [
	aCT
		defineMethodAsCompareOperator: #==;
		defineMethodReturnsReceiversClass: #class;
		setBreakpointOn: #primitiveFailed

]
