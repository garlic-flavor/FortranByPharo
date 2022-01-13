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
SWMBTofJS >> filename [
	^ 'cache/', super filename, '.mjs'
]

{ #category : #accessing }
SWMBTofJS >> mangledName [
	^ self class mangleClass safeSelectorNameOf: (method class = ByteSymbol ifTrue: [ method ] ifFalse: [ self method selector ])
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putBlock: aBlock [
	self stream log.

	self
		put: 'function';
		putArguments: aBlock arguments;
		put: '{';
		putSequenceWithReturn: aBlock body;
		put: '}'
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putBlockAsExpression: aBlock [
	self stream log.
	
	self
		put: '(';
		putBlock: aBlock;
		put: ')()'
]

{ #category : #'code generation' }
SWMBTofJS >> putCascade: aRBCascadeNode [
	|variables receiver|
	variables := (Set newFrom: aRBCascadeNode allVariables) asArray.
	self put: '(function('.
	variables do: [ :each | self stream put: each name; put: ', ' ].
	self put: '_receiver_) {'; cr.
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
	variables do: [ :each | self put: each name; put: ', ' ].
	self << aRBCascadeNode receiver; put: ')'.
	
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putIfFalse: aNode [
	self stream log.

	aNode lastIsReturn ifTrue: [
		self
			put: 'if(!(';
			<< aNode receiver;
			put: '))';
			<< (aNode arguments at: 1)
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
	
	aNode lastIsReturn ifTrue: [
		self
			put: 'if(';
			<< aNode receiver;
			put: ')';
			<< (aNode arguments at: 1)
	] ifFalse: [
		self
			put: '(';
			<< aNode receiver;
			put: ') ? ';
			putBlockAsExpression: (aNode arguments at: 1);
			put: ' : null'
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
			put: ') ? ';
 			putBlockAsExpression: (aNode arguments at: 1);
			put: ' : ';
			putBlockAsExpression: (aNode arguments at: 2)
	]
]

{ #category : #'code generation' }
SWMBTofJS >> putSelf [
	self put: (self method methodClass class = Metaclass ifTrue: [ self method methodClass soleInstance name ] ifFalse: [ 'this' ])
]

{ #category : #'code generation' }
SWMBTofJS >> putStatementDelimiter [
	self put: ';'
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

{ #category : #accessing }
SWMBTofJS >> type [
	^ type ifNil: [ type := #js ]
]
