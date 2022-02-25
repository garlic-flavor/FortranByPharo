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

{ #category : #'as yet unclassified' }
SWMBTofJS >> atBoolean: trueOrFalse [
	self put: (trueOrFalse ifTrue: [ 'true' ] ifFalse: [ 'false' ])
]

{ #category : #'code generation' }
SWMBTofJS >> atCascade: aCascadeNode [
	aCascadeNode receiver class = RBVariableNode ifTrue: [
		self
			putSequence;
			preventStatementDelimiter;
			preventNewline
	] ifFalse: [|receiver original|
		receiver := self children first children first.
		original := self children.
		self put: 'function(_receiver_){'; cr; incIndent; put: 'return ('; cr; incIndent.
		self children do: [:child|
			child children at: 1 put: (SWDecoder new
				node: (RBVariableNode named: #_receiver_ );
				result: receiver result;
				yourself).
			(self child: child)
				transpile.
		] separatedBy: [ self put: ', '; cr ].
		
		self put: ');'; cr; decIndent; decIndent; put: '}('.
		(self child: receiver)
			isExpression: true;
			transpile.
		self put: ')'
	]

]

{ #category : #accessing }
SWMBTofJS >> atClosure: aBlockNode [
	self halt.
	aBlockNode isExpression ifTrue: [
		self transpileChildren.
	] ifFalse: [
		self transpileChildrenWithDelimiter
	]

]

{ #category : #accessing }
SWMBTofJS >> mangledName [
	self halt; flag: #toRewrite.
"
	^ self class mangleClass safeSelectorNameOf: (method class = ByteSymbol ifTrue: [ method ] ifFalse: [ self method selector ])
"
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putArgumentDeclaration [
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

{ #category : #'as yet unclassified' }
SWMBTofJS >> putBoolean: trueOrFalse [
	self put: (trueOrFalse ifTrue: [ 'true' ] ifFalse: [ 'false' ])
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

{ #category : #'as yet unclassified' }
SWMBTofJS >> putIfNotNil: strait [
	self isExpression ifTrue: [|conditionNode|
		conditionNode := self children first node.
		conditionNode class = RBVariableNode ifTrue: [
			self
				put: '(';
				put: conditionNode name;
				put: (strait ifTrue: [ ' == ' ] ifFalse: [ ' != ' ]);
				put: ' null ? ';
				put: conditionNode name;
				put: ' : '.
			(self child: self children second)
				isExpression: true;
				putBlock.
			self  put: ')'
		] ifFalse: [
			self halt.
		]

	] ifFalse: [
		self halt.
		self put: 'if('.
		strait ifFalse: [ self put: '!' ].
		(self child: self children first)
			isExpression: true;
			transpile.
		self put: '){'; cr; incIndent.
		(self child: self children second)
			isExpression: false;
			putBlock.
		self decIndent; put: '}'; preventStatementDelimiter
	]

]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putIfNotNilIfNil: strait [
	self isExpression ifTrue: [
		self put: '('.
		(self child: self children first)
			isExpression: true;
			transpile.
		self put: (strait ifTrue: [ ' != null ' ] ifFalse: [ ' == null'  ]).
		self put: ' ? '.
		(self child: self children second)
			isExpression: true;
			putBlock.
		self 	put: ' : '.
		(self child: self children third)
			isExpression: true;
			putBlock.
		self put: ')'.
	] ifFalse: [
		self put: 'if('.
		(self child: self children first)
			isExpression: true;
			transpile.
		self put: (strait ifTrue: [ ' != null' ] ifFalse: [ ' == null'  ]).
		self put: '){'; cr; incIndent.
		(self child: self children second)
			isExpression: false;
			putBlock.
		self decIndent; put: '} else {'; cr; incIndent.
		(self child: self children third)
			isExpression: false;
			putBlock.
		self decIndent; put: '}'; preventStatementDelimiter
	]

]

{ #category : #'code generation' }
SWMBTofJS >> putIfTrue: strait [
	self isExpression ifTrue: [
		self halt.
	] ifFalse: [
		self put: 'if('.
		strait ifFalse: [ self put: '!' ].
		(self child: self children first)
			isExpression: true;
			transpile.
		self put: '){'; cr; incIndent.
		(self child: self children second)
			isExpression: false;
			putBlock.
		self decIndent; put: '}'; preventStatementDelimiter
	]

]

{ #category : #'code generation' }
SWMBTofJS >> putIfTrueIfFalse: strait [
	self isExpression ifTrue: [
		self put: '('.
		strait ifFalse: [ self put: '!' ].
		(self child: self children first)
			isExpression: true;
			transpile.
		self put: ' ? '.
		(self child: self children second)
			isExpression: true;
			putBlock.
		self 	put: ' : '.
		(self child: self children third)
			isExpression: true;
			putBlock.
		self put: ')'.
	] ifFalse: [
		self put: 'if('.
		strait ifFalse: [ self put: '!' ].
		(self child: self children first)
			isExpression: true;
			transpile.
		self put: '){'; cr; incIndent.
		(self child: self children second)
			isExpression: false;
			putBlock.
		self decIndent; put: '} else {'; cr; incIndent.
		(self child: self children third)
			isExpression: false;
			putBlock.
		self decIndent; put: '}'; preventStatementDelimiter
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
SWMBTofJS >> putNew [
	self
		put: 'new ';
		transpileChild: self decoder children first;
		putArguments: self decoder children allButFirst

]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putNil [
	self halt; flag: #toRewrite.
	self put: 'null'
]

{ #category : #enumerating }
SWMBTofJS >> putOnDo [
	self isExpression ifTrue: [
		self put: 'function(){ try {'; cr; incIndent; put: 'return '.
		(self child: self children first)
			isExpression: true;
			putBlock.
		self putStatementDelimiter; cr; decIndent; put: '} catch {'; cr; incIndent; put: 'return '.
		(self child: self children third)
			isExpression: true;
			putBlock.
		self putStatementDelimiter; cr; decIndent; put: '}}()'
	] ifFalse: [
		self put: 'try {'; cr; incIndent.
		(self child: self children first)
			isExpression: false;
			putBlock.
		self decIndent; put: '} catch {'; cr; incIndent.
		(self child: self children third)
			isExpression: false;
			putBlock.
		self decIndent; put: '}'; preventStatementDelimiter 
	]

"
	|receiver|
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
SWMBTofJS >> putVariableDeclaration [
	self
		put: 'var ';
		put: self decoder node name;
		put: ' = null'
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putYourself [
	self decoder node isExpression ifTrue: [
		self transpileChild: self decoder children first
	] ifFalse: [
		self halt.
	]

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
