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
		'parentStream',
		'temp'
	],
	#category : #'SWFortranByPharo-Transpiler-Common'
}

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
		transpileChildAsExpressionWithoutBracket: self children first

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
SWMethodBodyTranspiler >> atClosure: aBlockNode [
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
	self halt.
	self children allButLastDo: [ :child |
		(self child: child) putArgumentDeclaration
	].
	self preserveDeclaration: [
		(self child: self children last)
			isExpression: false;
			putSequence.
	].
	(self isExpression and: [ self expression node containsReturn not ]) ifTrue: [
		self putReturnSelf
	]
]

{ #category : #'dispatching-callback' }
SWMethodBodyTranspiler >> atNil [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> atReturn: aReturnNode [
	self putReturnKeyword; put: ' '; transpileChildAsExpressionWithoutBracket: (self children first)

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

{ #category : #'dispatching-callback' }
SWMethodBodyTranspiler >> atVariable: aVariableNode [
	(self pool haltList includes: aVariableNode name) ifTrue: [ self halt ].
	self putVariable

]

{ #category : #accessing }
SWMethodBodyTranspiler >> child: anExpression [
	^ self copy
		expression: anExpression;
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
	^ var
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
SWMethodBodyTranspiler >> parentStream [

	^ parentStream ifNil: [ parentStream := self pool stream ]
]

{ #category : #accessing }
SWMethodBodyTranspiler >> parentStream: anObject [

	parentStream := anObject
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
	self stream: self parentStream.
	aBlock value.
	self stream: original
]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> preserveDeclaration: aBlock [
self halt.	
	self declarationStream: self parentStream subStream.
	aBlock value.
	self parentStream append: self declarationStream

]

{ #category : #'code generation - protected' }
SWMethodBodyTranspiler >> preventNewline [
	self stream preventNewline
]

{ #category : #'code generation - protected' }
SWMethodBodyTranspiler >> preventStatementDelimiter [
	self stream preventDelimiter
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> put: anObject [
	self stream put: anObject asString
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putArgumentDeclaration [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putArguments: arguments [

	self put: '('.
	arguments do: [ :each |
		self transpileChildAsExpressionWithoutBracket: each
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
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putCascadeAsNotExpression [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putCharacter: c [
	self halt; flag: #toRewrite.
	self
		put: '"';
		put: c asString;
		put: '"'.
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putClassAccessor [
	self put: '.'
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putClosure: aNode [
	|tran|
	self halt; flag: #toRewrite.
	tran := self senders at: aNode.
	tran transpile.

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putCode: code [
	self halt; flag: #toRewrite.
	^ self putCode: code with: {  }
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
SWMethodBodyTranspiler >> putLocalsDeclaration [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putMessageWithSelector: aSelector [
	self
		transpileChildAsExpression: self children first;
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
		transpileChildAsExpression: self children first;
		put: ' ';
		put: anOp;
		put: ' ';
		transpileChildAsExpression: self children second

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putOrdinaryMessage [
	self putMessageWithSelector: self mangle

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putParameters: anArray [
	self halt; flag: #toRewrite.

	anArray do: [:each |
		self put: each asString
	] separatedBy: [
		self put: ', '
	]

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

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putSequenceAsExpression [

	1 < self children size ifTrue: [ self put: '('; incIndent ].
	self children do: [ :child |
		self transpileChildAsExpression: child
	] separatedBy: [ self putExpressionDelimiter; cr ].
	1 < self children size ifTrue: [ self decIndent; put: ')' ].

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putStatement: anExpression [
	|child|
	child := self copy
		expression: anExpression;
		isExpression: false;
		parentStream: self stream;
		stream: self stream subStream;
		transpile;
		putStatementDelimiter;
		cr;
		yourself.
	self stream append: child stream

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putStatementAsExpression: anExpression [
	|child|
	child := self copy
		expression: anExpression;
		isExpression: true;
		parentStream: self stream;
		stream: self stream subStream;
		transpile;
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

{ #category : #accessing }
SWMethodBodyTranspiler >> stream [
	^ stream
]

{ #category : #accessing }
SWMethodBodyTranspiler >> stream: anObject [

	stream := anObject.

]

{ #category : #accessing }
SWMethodBodyTranspiler >> subChild: anExpression [
	^ self copy
		expression: anExpression;
		parentStream: self stream;
		stream: self stream subStream;
		yourself
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
	self temp;
		declarationStream: self parentStream subStream;
		stream: self parentStream subStream;
		putVariableDeclarations;
		putSequence.
	self parentStream
		append: self declarationStream;
		append: self stream
]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> transpileChild: anExpression [
	^ self copy
		expression: anExpression;
		isExpression: self isExpression;
		transpile;
		yourself

]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> transpileChildAsExpression: anExpression [
	|needsBracket|
	needsBracket := anExpression node class = RBMessageNode.
	needsBracket ifTrue: [ self put: '(' ].
	self copy
		expression:  anExpression;
		isExpression: true;
		transpile.
	needsBracket ifTrue: [ self put: ')' ].

]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> transpileChildAsExpressionWithoutBracket: anExpression [
	self copy
		expression: anExpression;
		isExpression: true;
		transpile.

]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> transpileChildAsNotExpression: aDecoder [
	(self child: aDecoder)
		isExpression: false;
		transpile

]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> transpileChildren [
	self children do: [ :child |
		self transpileChild: child
	].

]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> transpileSubChild: anExpression [
	^ (self subChild: anExpression)
		isExpression: self isExpression;
		transpile;
		yourself

]
