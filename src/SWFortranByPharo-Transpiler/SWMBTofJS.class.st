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
SWMBTofJS class >> senderTranspilerClass [
	^ SWSTofJS
]

{ #category : #accessing }
SWMBTofJS >> atClosure: aBlockNode [
	aBlockNode isExpression ifTrue: [
		self transpileChildren.
	] ifFalse: [
		self halt.
	]

]

{ #category : #accessing }
SWMBTofJS >> mangledName [
	self halt; flag: #toRewrite.
"
	^ self class mangleClass safeSelectorNameOf: (method class = ByteSymbol ifTrue: [ method ] ifFalse: [ self method selector ])
"
]

{ #category : #'code generation' }
SWMBTofJS >> putBlock: aBlock [
	self halt; flag: #toRewrite.

	self
		put: '{';
		cr;
		incIndent.
	aBlock temporaries do: [ :each |
		self putVariableDeclarationOf: each name
	].
	self 
		withoutMessageNestDo: [
			self putSequence: aBlock body
		];
		decIndent;
		put: '}';
		preventStatementDelimiter

]

{ #category : #'code generation' }
SWMBTofJS >> putBlockAsExpression: aBlock [
	self halt; flag: #toRewrite.

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
	self halt; flag: #toRewrite.

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
	self withoutMessageNestDo: [
		self << aRBCascadeNode receiver
	]; put: ')'
	
]

{ #category : #streaming }
SWMBTofJS >> putFilenameOn: aStream [
	self halt; flag: #toRewrite.
	aStream << 'cache/'.
	super putBasenameOn: aStream.
	aStream << '.mjs'
]

{ #category : #'code generation' }
SWMBTofJS >> putIfFalse: aNode [
	self stream log.
	self halt; flag: #toRewrite.

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

{ #category : #'code generation' }
SWMBTofJS >> putIfTrue: aNode [
	self stream log.
	self halt; flag: #toRewrite.
	
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

{ #category : #'code generation' }
SWMBTofJS >> putIfTrueIfFalse [
	self decoder node isExpression ifTrue: [
		self
			put: '(';
			transpileChild: self decoder children first;
			put: ' ? ';
			transpileChild: self decoder children second;
			put: ' : ';
			transpileChild: self decoder children third;
			put: ')'.
		^ self
	].

	self halt.
"	
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
"
]

{ #category : #'code generation' }
SWMBTofJS >> putIfTrueIfFalse: aNode [
	self stream log.
	self halt; flag: #toRewrite.
	
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

{ #category : #'code generation' }
SWMBTofJS >> putImport: anArray from: aSource [
	self halt; flag: #toRewrite.
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

{ #category : #'code generation' }
SWMBTofJS >> putNew: aNode [
	self halt; flag: #toRewrite.
	self
		put: '(new ';
		<< aNode receiver;
		putArguments: aNode arguments;
		put: ')'
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putNil [
	self halt; flag: #toRewrite.
	self put: 'null'
]

{ #category : #enumerating }
SWMBTofJS >> putOnDo: aNode [ 
	|receiver|
	self halt; flag: #toRewrite.
	receiver := aNode receiver.
	aNode isExpression ifTrue: [	
		self halt; flag: #toImplement.
		receiver := receiver copy.
		receiver body addReturn.
	].

	self
		put: 'try';
		<< receiver;
		put: 'catch'.
	aNode arguments second arguments ifNotEmpty: [
		self putArguments: aNode arguments second arguments
	].
	self
		<< aNode arguments second		
"
	aNode isExpression ifTrue: [
		transpiler put: '(function(){'
	].
	transpiler
		put: 'try {'; cr;
		incIndent.
	aNode isExpression ifTrue: [
		transpiler putSequenceWithReturn: aNode receiver
	] ifFalse: [
		transpiler putSequence: aNode receiver
	].
	transpiler
		decIndent;
		put: '} catch'.
	(aNode arguments at: 2) arguments ifNotEmpty: [
		transpiler putArguments: (aNode arguments at: 2) arguments
	].
	transpiler
		put: ' {'; cr;
		incIndent.
	aNode isExpression ifTrue: [
		transpiler putSequenceWithReturn: (aNode arguments at: 2)
	] ifFalse: [
		transpiler putSequence: (aNode arguments at: 2)
	].
	transpiler
		decIndent;
		put: '}'.
	aNode isExpression ifTrue: [
		transpiler put: '})()'
	]
"
]

{ #category : #'code generation' }
SWMBTofJS >> putOpBinary: aNode [
	self halt; flag: #toRewrite.
	super putOpBinary: (aNode selector = #= ifTrue: [
		aNode copy
			selector: #==;
			yourself
	] ifFalse: [ aNode ])
]

{ #category : #'code generation' }
SWMBTofJS >> putOrdinaryCallee: aNode [
	self halt; flag: #toRewrite.
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

{ #category : #'code generation' }
SWMBTofJS >> putReturnThisClassName [
	self halt; flag: #toRewrite.
	self
		put: 'return this.name';
		putStatementDelimiter;
		cr
]

{ #category : #'code generation' }
SWMBTofJS >> putSelf [
	self halt; flag: #toRewrite.

	self put: (self receiverClass isClassSide ifTrue: [ self receiverClass soleInstance name ] ifFalse: [ 'self' ])
]

{ #category : #'code generation' }
SWMBTofJS >> putSelfDefinition [
	self halt; flag: #toRewrite.
	self put: 'var self = this;'; cr
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putStdOut [
	self
		put: 'console.log';
		putArguments: (self decoder children copyFrom: 2 to: 2)

]

{ #category : #'code generation' }
SWMBTofJS >> putVariableDeclarationOf: aVariableName [
	self halt; flag: #toRewrite.
	self
		put: 'var ';
		put: aVariableName;
		put: ' = null;';
		cr

		
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> put_upToEnd: aNode [
	self error; flag: #toRemove.
	self
		withoutMessageNestDo: [
			self << aNode receiver
		];
		putClassAccessor;
		put: 'read()'
]

{ #category : #'code generation' }
SWMBTofJS >> trySimpleCascade: aRBCascadeNode [
	self halt; flag: #toRewrite.

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
