Extension { #name : #ProtoObject }

{ #category : #'*SWFortranByPharo-Analyzer' }
ProtoObject class >> initializeInstanceSideTranspiler: aCT [
	aCT
		defineMethod: #== as: Boolean;
		defineMethodReturnsReceiversClass: #class;
		setBreakpointOn: #primitiveFailed

]
