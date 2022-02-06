Extension { #name : #Object }

{ #category : #'*SWFortranByPharo-Analyzer' }
Object class >> initializeInstanceSideTranspiler: transpiler [
	self error; flag: #toRemove.
	transpiler
		setBreakpointOn: #subclassResponsibility;
		defineMethodAsCompareOperator: #=;
		defineMethod: #asString asReturn: String;
		defineMethodReturnsReceiver: #copy;
		defineMethodReturnsReceiver: #changed:;
		defineMethod: #at: as: [:newT |
			self error; flag: #toRemove.
"
			(aCallee receiverClass = String or: [ aCallee receiverClass = ByteString ]) ifTrue: [ Character ] ifFalse: [
				self halt
			]
"
		];
		defineMethodReturnsReceiver: #yourself as: [ :newT |
			newT
				senderGenerator: [ :t :node | t putYourself: node ];
				yourself
		]
]
