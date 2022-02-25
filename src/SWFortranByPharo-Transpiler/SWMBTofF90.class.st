"
SWMBTofF90 is an implementation of SWMethodBodyTranspiler for Fortran 90.
"
Class {
	#name : #SWMBTofF90,
	#superclass : #SWMethodBodyTranspiler,
	#category : #'SWFortranByPharo-Transpiler-F90'
}

{ #category : #accessing }
SWMBTofF90 class >> classTranspilerClass [
	^ SWCDTofF90
]

{ #category : #constants }
SWMBTofF90 class >> mangleClass [
	^ SWMangleOfF90
]

{ #category : #accessing }
SWMBTofF90 class >> methodDefinitionTranspilerClass [
	^ SWMDTofF90
]

{ #category : #accessing }
SWMBTofF90 class >> senderTranspilerClass [
	^ SWSTofF90
]

{ #category : #'code generation' }
SWMBTofF90 >> atCascade: aCascadeNode [
	aCascadeNode receiver class = RBVariableNode ifTrue: [
		self
			transpileChildrenWithDelimiter;
			preventStatementDelimiter;
			preventNewline
	] ifFalse: [|receiver original|
		receiver := self children first children first.
		original := self children.
		self put: 'function(_receiver_){'; cr; incIndent; put: 'return ('.
		self children do: [:child|
			child children at: 1 put: (SWDecoder new
				node: (RBVariableNode named: #_receiver_ );
				result: receiver result;
				yourself).
			(self child: child)
				transpile.
		] separatedBy: [ self put: ', ' ].
		
		self decIndent; put: '); }('.
		(self child: receiver)
			isExpression: true;
			transpile.
		self put: ')'
	]

]

{ #category : #'code generation' }
SWMBTofF90 >> putCascade: aRBCascadeNode [

	(self trySimpleCascade: aRBCascadeNode) ifTrue: [ ^ self ].

	self halt; flag: #toImplement.

]

{ #category : #'code generation' }
SWMBTofF90 >> trySimpleCascade: aRBCascadeNode [

	aRBCascadeNode receiver class = RBVariableNode ifFalse: [ ^ false ].
	aRBCascadeNode isExpression ifFalse: [
		aRBCascadeNode messages do: [ :each |
			self putStatement: each
		].
		self
			preventStatementDelimiter;
			preventNewline
	].
	^ true

]
