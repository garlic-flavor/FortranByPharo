"
I transpile Pharo to ECMAScript.
"
Class {
	#name : #SWMBTofJS,
	#superclass : #SWMethodBodyTranspiler,
	#category : #'SWFortranByPharo-Transpiler-JS'
}

{ #category : #accessing }
SWMBTofJS class >> classTranspilerClass [
	^ SWCDTofJS
]

{ #category : #constants }
SWMBTofJS class >> mangleClass [
	^ SWMangleOfJS 
]

{ #category : #'as yet unclassified' }
SWMBTofJS class >> methodDefinitionTranspilerClass [
	^ SWMDTofJS
]

{ #category : #accessing }
SWMBTofJS >> mangledName [
	^ self class mangleClass safeSelectorNameOf: (method class = ByteSymbol ifTrue: [ method ] ifFalse: [ self method selector ])
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putBlock: aBlock [
	self stream log.

	self
		put: '{';
		cr;
		incIndent;
		withoutMessageNestDo: [
			self putSequence: aBlock body
		];
		decIndent;
		put: '}';
		preventStatementDelimiter

]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putBlockAsExpression: aBlock [
	self stream log.
	
	aBlock statements size = 1 ifTrue: [
		self << (aBlock statements at: 1)
	] ifFalse: [
		self
			put: '(';
			putClosure: aBlock;
			put: ')()'
	]
]

{ #category : #'code generation' }
SWMBTofJS >> putCascade: aRBCascadeNode [
	|variables receiver|

	(self trySimpleCascade: aRBCascadeNode) ifTrue: [ ^ self ].

	variables := (Set newFrom: aRBCascadeNode allVariables) asArray.
	self put: '(function(_receiver_) {'; cr.
	self stream incIndent.
	receiver := RBVariableNode named: #_receiver_.
	aRBCascadeNode messages doWithIndex: [ :msgNode :idx |
		idx = aRBCascadeNode messages size ifTrue: [
			self put: 'return '
		].
		self
			putMessage: msgNode withReceiver: receiver;
			putStatementDelimiter;
			cr
	].
	self stream decIndent.
	self put: '})('.
	self << aRBCascadeNode receiver; put: ')'.
	
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putClosure: aBlock [
	self stream log.

	self
		put: 'function';
		putArguments: aBlock arguments;
		put: '{';
		cr;
		incIndent;
		putSequenceWithReturn: aBlock body;
		decIndent;
		put: '}'

]

{ #category : #accessing }
SWMBTofJS >> putFilenameOn: aStream [
	aStream << 'cache/'.
	super putFilenameOn: aStream.
	aStream << '.mjs'
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putIfFalse: aNode [
	self stream log.

	(aNode lastIsReturn or: [ aNode parent class = RBSequenceNode ]) ifTrue: [
		self
			put: 'if(!';
			<< aNode receiver;
			put: ')';
			putBlock: (aNode arguments at: 1)
	] ifFalse: [
		self
			put: '(!(';
			<< aNode receiver;
			put: ')) ? ';
			putBlockAsExpression: (aNode arguments at: 1);
			put: ' : null'
	]
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putIfTrue: aNode [
	self stream log.
	
	aNode isExpression ifTrue: [
		self
			put: '(';
			<< aNode receiver;
			put: ' ? ';
			putBlockAsExpression: (aNode arguments at: 1);
			put: ' : null)'
	] ifFalse: [
		self
			put: 'if(';
			<< aNode receiver;
			put: ')';
			putBlock: (aNode arguments at: 1)
	]
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putIfTrueIfFalse: aNode [
	self stream log.
	
	aNode lastIsReturn ifTrue: [
		self
			put: 'if(';
			<< aNode receiver;
			put: ')';
			<< (aNode arguments at: 1);
			put: 'else ';
			<< (aNode arguments at: 2)
	] ifFalse: [
		self
			put: '(';
			<< aNode receiver;
			put: ' ? ';
 			putBlockAsExpression: (aNode arguments at: 1);
			put: ' : ';
			putBlockAsExpression: (aNode arguments at: 2);
			put: ')'
	]
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putImport: anArray from: aSource [
	self put: 'import {'.
	anArray do: [ :each |
		self put: each asString
	] separatedBy: [
		self put: ', '
	].
	self
		put: '} from ';
		putString: ('../script/', aSource, '.mjs')
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putNew: aNode [
	self
		put: '(new ';
		<< aNode receiver;
		putArguments: aNode arguments;
		put: ')'
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putOpBinary: aNode [
	super putOpBinary: (aNode selector = #= ifTrue: [
		aNode copy
			selector: #==;
			yourself
	] ifFalse: [ aNode ])
]

{ #category : #'code generation' }
SWMBTofJS >> putOrdinaryCallee: aNode [
	self stream log.
	self methodClass ifNil: [ ^ super putOrdinaryCallee: aNode ].
	self methodClass isClassSide ifFalse: [ ^ super putOrdinaryCallee: aNode ].
	self methodClass = self receiverClass ifTrue: [ ^ super putOrdinaryCallee: aNode ].

	self
		put: self methodClass instanceSide name;
		putClassAccessor;
		put: (self class mangleClass mangle: self);
		putClassAccessor;
		put: 'call';
		putArguments: ({RBVariableNode named: self receiverClass instanceSide name}, aNode arguments)

]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putReturnThisClassName [
	self
		put: 'return this.name';
		putStatementDelimiter;
		cr
]

{ #category : #'code generation' }
SWMBTofJS >> putSelf [

	self put: (self receiverClass isClassSide ifTrue: [ self receiverClass soleInstance name ] ifFalse: [ 'self' ])
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putSelfDefinition [
	self put: 'var self = this;'; cr
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putStdOut: arguments [
	self stream log.
	self
		put: 'console.log';
		putArguments: arguments
]

{ #category : #'code generation' }
SWMBTofJS >> putVariableDeclarationOf: aVariableInfo [
	self
		put: 'var ';
		put: aVariableInfo name;
		put: ' = null;';
		cr

		
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putYourself: aNode [
	self stream log.
	self << aNode receiver
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> put_asString: aNode [
	self stream log.
	self
		<< aNode receiver;
		putClassAccessor;
		put: 'toString()'
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> put_inject_into_: aNode [
	self
		<< aNode receiver;
		putClassAccessor;
		put: 'reduce(';
		<< (aNode arguments at: 2);
		put: ', ';
		<< (aNode arguments at: 1);
		put: ')'
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> put_on_do_: aNode [

	aNode isExpression ifTrue: [
		self put: '(function(){'
	].
	self
		put: 'try {'; cr;
		incIndent.
	aNode isExpression ifTrue: [
		self putSequenceWithReturn: aNode receiver
	] ifFalse: [
		self putSequence: aNode receiver
	].
	self
		decIndent;
		put: '} catch'.
	(aNode arguments at: 2) arguments ifNotEmpty: [
		self putArguments: (aNode arguments at: 2) arguments
	].
	self
		put: ' {'; cr;
		incIndent.
	aNode isExpression ifTrue: [
		self putSequenceWithReturn: (aNode arguments at: 2)
	] ifFalse: [
		self putSequence: (aNode arguments at: 2)
	].
	self
		decIndent;
		put: '}'.
	aNode isExpression ifTrue: [
		self put: '})()'
	]

]

{ #category : #'as yet unclassified' }
SWMBTofJS >> trySimpleCascade: aRBCascadeNode [

	aRBCascadeNode receiver class = RBVariableNode ifFalse: [ ^ false ].
	aRBCascadeNode isExpression ifTrue: [
		self put: '('.
		aRBCascadeNode messages do: [ :each |
			self << each
		] separatedBy: [ self put: ', ' ].
		self put: ')'.
	] ifFalse: [
		aRBCascadeNode messages do: [ :each |
			self putStatement: each
		].
		self
			preventStatementDelimiter;
			preventNewline
	].
	^ true

]

{ #category : #accessing }
SWMBTofJS >> type [
	^ type ifNil: [ type := #js ]
]
