"
I transpile a method of Pharo class.
"
Class {
	#name : #SWMethodBodyTranspiler,
	#superclass : #Object,
	#instVars : [
		'expression',
		'stream',
		'pool',
		'isExpression',
		'declarationStream',
		'previousStream',
		'temp'
	],
	#category : #'SWFortranByPharo-Transpiler-Common'
}

{ #category : #accessing }
SWMethodBodyTranspiler >> append: aChild [
	self stream
		append: aChild declarationStream;
		append: aChild previousStream;
		append: aChild stream
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> at: anObject [
	self halt.
]

{ #category : #'dispatching-callback' }
SWMethodBodyTranspiler >> atArray: anArrayNode [
	self putArrayHeader.
	self children do: [ :child |
		self transpileChild: child
	] separatedBy: [ self putArraySeparator ].
	self putArrayFooter.

]

{ #category : #'dispatching-callback' }
SWMethodBodyTranspiler >> atAssign: anAssignNode [
	self
		transpileChild: self children second;
		put: ' = ';
		transpileChildWithoutBracket: self children first

]

{ #category : #'dispatching-callback' }
SWMethodBodyTranspiler >> atBlock: aBlockNode [
	^ self subclassResponsibility 
]

{ #category : #'dispatching-callback' }
SWMethodBodyTranspiler >> atBoolean: trueOrFalse [
	^ self subclassResponsibility 
]

{ #category : #'dispatching-callback' }
SWMethodBodyTranspiler >> atCascade: aCascadeNode [
	self isExpression ifTrue: [
		self putCascadeAsExpression
	] ifFalse: [
		self putCascadeAsNotExpression
	]
]

{ #category : #'dispatching-callback' }
SWMethodBodyTranspiler >> atCharacter: aChar [
	^ self subclassResponsibility 
]

{ #category : #'dispatching-callback' }
SWMethodBodyTranspiler >> atFloat: aFloat [
	self put: aFloat asString
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> atInteger: anInteger [
	self put: anInteger asString
]

{ #category : #'dispatching-callback' }
SWMethodBodyTranspiler >> atLiteralValue:  aLiteralValueNode [
	aLiteralValueNode value ifNotNil: [ :val |
		val dispatchTo: self
	] ifNil: [
		self putNil
	]

]

{ #category : #'dispatching-callback' }
SWMethodBodyTranspiler >> atMessage: aMessageNode [
	(self pool haltList includes: aMessageNode selector) ifTrue: [ self halt ].
	(self pool predefinedSenderTranspiler: self expression senderInfo) ifNotNil: [ :predefined |
		predefined value: self
	] ifNil: [
		self putOrdinaryMessage
	].

]

{ #category : #'dispatching-callback' }
SWMethodBodyTranspiler >> atMethod: aMethodNode [
	|child|
	self putArgumentDeclaration: self expression arguments.
	self put: '{'; cr; incIndent;
		putSelfDeclaration.
	child := (self scopeChild: self expression)
		putVariableDeclarations;
		putSequence.
	self append: child.
	self expression node containsReturn ifFalse: [ self putReturnSelf ].
	self decIndent; put: '}'; cr
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> atReturn: aReturnNode [
	self putReturnKeyword; put: ' '; transpileChildWithoutBracket: (self children first)

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> atSequence: aSequenceNode [
	self halt.


]

{ #category : #'dispatching-callback' }
SWMethodBodyTranspiler >> atString: aString [
	self
		put: '"';
		put: aString;
		put: '"'
]

{ #category : #accessing }
SWMethodBodyTranspiler >> atSymbol: aSymbol [
	self
		put: '"';
		put: aSymbol asString;
		put: '"'
]

{ #category : #'dispatching-callback' }
SWMethodBodyTranspiler >> atVariable: aVariableNode [
	(self pool haltList includes: aVariableNode name) ifTrue: [ self halt ].
	self putVariable

]

{ #category : #accessing }
SWMethodBodyTranspiler >> child: anExpression [
	^ self copy
		expression: anExpression;
		isExpression: true;
		yourself
]

{ #category : #accessing }
SWMethodBodyTranspiler >> children [
	^ expression children
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> cr [

	self stream putLine
]

{ #category : #'code generation - protected' }
SWMethodBodyTranspiler >> decIndent [
	self stream decIndent
]

{ #category : #accessing }
SWMethodBodyTranspiler >> declarationStream [

	^ declarationStream
]

{ #category : #accessing }
SWMethodBodyTranspiler >> declarationStream: anObject [

	declarationStream := anObject
]

{ #category : #accessing }
SWMethodBodyTranspiler >> expression [

	^ expression
]

{ #category : #accessing }
SWMethodBodyTranspiler >> expression: anObject [

	expression := anObject
]

{ #category : #'code generation - protected' }
SWMethodBodyTranspiler >> incIndent [
	self stream incIndent
]

{ #category : #accessing }
SWMethodBodyTranspiler >> isExpression [

	^ isExpression ifNil: [ isExpression := false ]
]

{ #category : #accessing }
SWMethodBodyTranspiler >> isExpression: anObject [

	isExpression := anObject
]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> makeNewVariable: type [
	|var|
	var := self expression addToSlot: (self newVariableName) as: type.
	self putVariableDeclarationOf: var name.
	^ self expression copy
		node: (RBVariableNode named: var name);
		result: var;
		children: nil;
		yourself

]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> mangle [
	^ self pool class mangleClass mangle: self expression
]

{ #category : #accessing }
SWMethodBodyTranspiler >> method [
	^ self expression method
]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> newVariableName [
	|name|
	name := self temp nextName.

	^ (self expression slot anySatisfy: [ :each | each name = name  ]) ifTrue: [
		self newVariableName
	] ifFalse: [ name ].

]

{ #category : #accessing }
SWMethodBodyTranspiler >> node [
	^ expression node
]

{ #category : #accessing }
SWMethodBodyTranspiler >> pool [

	^ pool
]

{ #category : #accessing }
SWMethodBodyTranspiler >> pool: anObject [

	pool := anObject
]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> preserveCurrentStatement: aBlock [
	|original|
	original := self stream.
	self stream: self previousStream.
	aBlock value.
	self stream: original
]

{ #category : #'code generation - protected' }
SWMethodBodyTranspiler >> preventNewline [
	self stream preventNewline
]

{ #category : #'code generation - protected' }
SWMethodBodyTranspiler >> preventStatementDelimiter [
	self stream preventDelimiter
]

{ #category : #accessing }
SWMethodBodyTranspiler >> previousStream [

	^ previousStream
]

{ #category : #accessing }
SWMethodBodyTranspiler >> previousStream: anObject [

	previousStream := anObject
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> put: anObject [
	self stream put: anObject asString
]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> putArgumentDeclaration: anArrayOfNode [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putArguments: arguments [

	self put: '('.
	arguments do: [ :each |
		self transpileChildWithoutBracket: each
	] separatedBy: [
		self put: ', '
	].

	self put: ')'

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putArrayFooter [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putArrayHeader [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putArraySeparator [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putAtIfAbsent [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putAtPut [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putCascadeAsExpression [
	self node receiver class = RBVariableNode ifTrue: [
		self putCascadeAsExpressionSimple
	] ifFalse: [
		self putCascadeAsExpressionWithTemp
	]
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putCascadeAsExpressionSimple [
	self preserveCurrentStatement: [
		self children allButLastDo: [ :child |
			self putStatement: child
		]
	].
	self transpileChildWithoutBracket: self children last

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putCascadeAsExpressionWithTemp [
	|receiverExp receiver|
	receiverExp := self children first children first.
	receiver := self makeNewVariable: receiverExp result.
	self children do: [ :child | child children at: 1 put: receiver ].
	self children addFirst: (receiverExp copy
		node: (RBAssignmentNode variable: (RBVariableNode named: receiver result name) value: receiverExp node);
		children: { receiverExp. receiver };
		yourself).
	self preserveCurrentStatement: [
		self children allButLastDo: [ :child | self putStatement: child ]
	].
	self transpileChildWithoutBracket: self children last
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putCascadeAsNotExpression [
	self node receiver class = RBVariableNode ifTrue: [
		self putCascadeAsNotExpressionSimple
	] ifFalse: [
		self putCascadeAsNotExpressionWithTemp
	]
]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> putCascadeAsNotExpressionSimple [
	self putSequence; preventStatementDelimiter; preventNewline
]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> putCascadeAsNotExpressionWithTemp [
	|receiverExp receiver|

	receiverExp := self children first children first.
	receiver := self makeNewVariable: receiverExp result.

	self children do: [ :child |  child children at: 1 put: receiver ].
	self children addFirst: (receiverExp copy
		node: (RBAssignmentNode variable: (RBVariableNode named: receiver result name) value: receiverExp node);
		children: { receiverExp. receiver };
		yourself).
	self putSequence
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putClassAccessor [
	self put: '.'
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putCode: code with: anAssociationArray [
	"when a line in code ends with $\, the line continues to the next."
	|matcher leftPad escaped|
	self halt; flag: #toRewrite.

	matcher := RxMatcher forString: '(\\\r|\s+\\$)'.
	escaped := matcher copy: code replacingMatchesWith: ''.
	leftPad := (escaped findFirst: [ :c | c ~= Character tab ])-1.
	matcher := RxMatcher forString: '\t+'.
	escaped := matcher copy: escaped translatingMatchesUsing: [ :m |
		String tab repeat: (m size - leftPad)
	].
	anAssociationArray do: [ :each |
		escaped := escaped copyReplaceAll: each key with: each value.
	].
	self put: escaped.


]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putEnsure [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putExpressionDelimiter [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putIfNotNilIfNil: strait [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putIfTrueIfFalse: strait [
	^ self subclassResponsibility
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putImport: anArray from: aSource [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putMessageWithSelector: aSelector [
	self
		transpileChildWithoutBracket: self children first;
		putClassAccessor;
		put: aSelector;
		putArguments: self children allButFirst

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putNew [
	^ self subclassResponsibility
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putNil [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putOnDo [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putOpBinary [
	self putOpBinaryWith: self node selector

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putOpBinaryWith: anOp [
	self
		transpileChild: self children first;
		put: ' ';
		put: anOp;
		put: ' ';
		transpileChild: self children second

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putOrdinaryMessage [
	self putMessageWithSelector: self mangle

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putReturnKeyword [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putReturnSelf [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putSelf [
	self halt; flag: #toRemove.
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putSelfClass [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putSelfDeclaration [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putSequence [
	self children do: [ :child |
		self putStatement: child
	]

]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> putSequenceAndReturn [
	|lastchild|
	self children allButLastDo: [ :child |
		self putStatement: child
	].
	lastchild := (self statementChild: self expression)
		putReturnKeyword; put: ' '; transpileChildWithoutBracket: self children last;
		putStatementDelimiter; cr;
		yourself.
	self stream append: lastchild stream

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putStatement: anExpression [
	|child|
	child := (self statementChild: anExpression)
		transpile;
		putStatementDelimiter;
		cr;
		yourself.
	self stream append: child stream

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putStatementDelimiter [
	self stream putDelimiter
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putVariable [

	self put: self node name
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putVariableDeclaration [
	self
		putVariableDeclarationOf: self node name;
		preventStatementDelimiter; preventNewline
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putVariableDeclarationOf: aName [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putVariableDeclarations [
	self expression locals do: [ :loc |
		self putVariableDeclarationOf: loc name
	]

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putYourself [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWMethodBodyTranspiler >> receiverClass [
	^ self expression receiverClass
]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> scopeChild: anExpression [
	^ self copy
		expression: anExpression;
		isExpression: false;
		declarationStream: self stream subStream;
		previousStream: self stream subStream;
		stream: self stream subStream;
		yourself
]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> statementChild: anExpression [
	^ self copy
		expression: anExpression;
		isExpression: false;
		previousStream: self stream;
		stream: self stream subStream;
		yourself.
]

{ #category : #accessing }
SWMethodBodyTranspiler >> stream [
	^ stream ifNil: [ stream := self pool stream ]
]

{ #category : #accessing }
SWMethodBodyTranspiler >> stream: anObject [

	stream := anObject.

]

{ #category : #accessing }
SWMethodBodyTranspiler >> temp [

	^ temp ifNil: [ temp := SWTempManager new ]
]

{ #category : #accessing }
SWMethodBodyTranspiler >> temp: anObject [

	temp := anObject
]

{ #category : #'public API' }
SWMethodBodyTranspiler >> transpile [
	self temp.
	self node dispatchTo: self.

]

{ #category : #'public API' }
SWMethodBodyTranspiler >> transpileAsMain [
	|child|
	self temp.
	child := (self scopeChild: self expression)
		putVariableDeclarations;
		putSequence;
		yourself.
	self append: child

]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> transpileChild: anExpression [
	|needsBracket|
	needsBracket := anExpression node class = RBMessageNode.
	needsBracket ifTrue: [ self put: '(' ].
	self transpileChildWithoutBracket: anExpression.
	needsBracket ifTrue: [ self put: ')' ].

]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> transpileChildWithoutBracket: anExpression [
	(self child: anExpression) transpile

]
