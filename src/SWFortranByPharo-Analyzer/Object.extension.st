Extension { #name : #Object }

{ #category : #'*SWFortranByPharo-Analyzer' }
Object class >> initializeInstanceSideTranspiler: transpiler [
	transpiler
		setBreakpointOn: #subclassResponsibility;
		defineMethod: #asString as: String;
		defineMethodReturnsReceiver: #copy;
		defineMethod: #at: as: [ :aCallee |
			(aCallee receiverClass = String or: [ aCallee receiverClass = ByteString ]) ifTrue: [ Character ] ifFalse: [
				self halt
			]
		];
		defineMethod: #yourself as: self with: [ :t :node | t putYourself: node ]
]
