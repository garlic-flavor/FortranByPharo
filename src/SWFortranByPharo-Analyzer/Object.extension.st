Extension { #name : #Object }

{ #category : #'*SWFortranByPharo-Analyzer' }
Object class >> initializeInstanceSideTranspiler: transpiler [
	transpiler
		setBreakpointOn: #subclassResponsibility;
		defineMethod: #asString as: String;
		defineMethod: #at: as: [ :aCallee |
			aCallee receiverClass = String ifTrue: [ Character ] ifFalse: [
				self halt
			]
		]
]
