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
		'declarationStream'
	],
	#category : #'SWFortranByPharo-Transpiler-Common'
}

{ #category : #'code generation' }
SWMethodBodyTranspiler >> at: anObject [
	self halt.
]

{ #category : #accessing }
SWMethodBodyTranspiler >> atArray: anArrayNode [
	self putArrayHeader.
	self children do: [ :child |
		self transpileChild: child
	] separatedBy: [ self putArraySeparator ].
	self putArrayFooter.

]

{ #category : #accessing }
SWMethodBodyTranspiler >> atAssignTo: aVariable with: aValue [
	self
		transpileChild: self children second;
		put: ' = ';
		transpileChild: self children first

]

{ #category : #accessing }
SWMethodBodyTranspiler >> atBoolean: trueOrFalse [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWMethodBodyTranspiler >> atCascade: aCascadeNode [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWMethodBodyTranspiler >> atCharacter: aChar [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWMethodBodyTranspiler >> atClosure: aBlockNode [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWMethodBodyTranspiler >> atFloat: aFloat [
	self put: aFloat asString
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> atInteger: anInteger [
	self put: anInteger asString
]

{ #category : #accessing }
SWMethodBodyTranspiler >> atMessage: aMessageNode [
	(self pool haltList includes: aMessageNode selector) ifTrue: [ self halt ].
	(self pool predefinedSenderTranspiler: self expression senderInfo) ifNotNil: [ :predefined |
		predefined value: self
	] ifNil: [
		self putOrdinaryMessage
	].

]

{ #category : #accessing }
SWMethodBodyTranspiler >> atMethod: aMethodNode [
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

{ #category : #accessing }
SWMethodBodyTranspiler >> atNil [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> atReturn: aReturnNode [
	self putReturnKeyword; put: ' '.
	(self child: self children first)
		isExpression: true;
		transpile.

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> atSequence: aSequenceNode [
	self halt.


]

{ #category : #accessing }
SWMethodBodyTranspiler >> atString: aString [
	self
		put: '"';
		put: aString;
		put: '"'
]

{ #category : #accessing }
SWMethodBodyTranspiler >> atVariable: aVariableNode [
	(self pool haltList includes: aVariableNode name) ifTrue: [ self halt ].

	aVariableNode parent class = RBMethodNode ifTrue: [ ^self ].
	aVariableNode parent class = RBSequenceNode ifTrue: [
		^ self putVariableDeclaration
	].
	self putVariable

]

{ #category : #accessing }
SWMethodBodyTranspiler >> child: anExpression [
	^ self class new
		expression: anExpression;
		stream: self stream;
		declarationStream: self declarationStream;
		pool: self pool;
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
	var := self expression addToSlot: (self newVariableName: nil) as: type.
	self putVariableDeclaration: var name.
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
SWMethodBodyTranspiler >> newVariableName: prev [
	|counter name|
	counter := prev ifNil: [ 0 ].
	name := String streamContents: [ :s | s << 'temp_'; << counter asString ].

	^ (self expression slot anySatisfy: [ :each | each name = name  ]) ifTrue: [
		self newVariableName: counter + 1
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
SWMethodBodyTranspiler >> preserveDeclaration: aBlock [
	self declarationStream: self stream.
	self stream: self stream subStream.
	aBlock value.
	self declarationStream append: self stream.
	self stream: self declarationStream.

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

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> putArgumentDeclaration [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putArguments: arguments [

	self put: '('.
	arguments do: [ :each |
		self transpileChild: each
	] separatedBy: [
		self put: ', '
	].

	self put: ')'

]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> putArrayFooter [
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> putArrayHeader [
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> putArraySeparator [
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> putAtIfAbsent [
]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> putAtPut [
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

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> putEnsure [
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> putLocalsDeclaration [
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> putMessageWithSelector: aSelector [
	self
		transpileChild: self children first;
		putClassAccessor;
		put: aSelector;
		putArguments: self children allButFirst

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putNew [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
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
		transpileChildWithBracket: self children first;
		put: ' ';
		put: anOp;
		put: ' ';
		transpileChildWithBracket: self children second

]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> putSelfClass [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putSelfDeclaration [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putSequence [
	self isExpression ifTrue: [
		self children ifEmpty: [ ^ self ].
		1 < self children size ifTrue: [ self put: '(' ].
		self children allButLastDo: [ :child |
			(self child: child)
				isExpression: true;
				transpile.
			self put: ', '; cr
		].
		(self child: self children last)
			isExpression: true;
			transpile.
		1 < self children size ifTrue: [ self put: ')' ].
	] ifFalse: [
		self children do: [ :child |
			(self child: child)
				isExpression: false;
				transpile.
			self putStatementDelimiter;  cr
		]
	]

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putStatementDelimiter [
	self stream putDelimiter
]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> putVariable [

	self put: self node name
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putVariableDeclaration [
	self
		putVariableDeclaration: self node name;
		preventStatementDelimiter; preventNewline
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putVariableDeclaration: aName [
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> putYourself [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWMethodBodyTranspiler >> receiverClass [
	^ self expression receiverClass
]

{ #category : #accessing }
SWMethodBodyTranspiler >> stream [
	^ stream ifNil: [ stream := self pool stream ]

]

{ #category : #accessing }
SWMethodBodyTranspiler >> stream: anObject [

	stream := anObject.

]

{ #category : #'public API' }
SWMethodBodyTranspiler >> transpile [
	self node dispatchTo: self.

]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> transpileChild: aDecoder [
	(self child: aDecoder)
		isExpression: self isExpression;
		transpile

]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> transpileChildAsExpression: aDecoder [
	(self child: aDecoder)
		isExpression: true;
		transpile

]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> transpileChildAsNotExpression: aDecoder [
	(self child: aDecoder)
		isExpression: false;
		transpile

]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> transpileChildWithBracket: aDecoder [
	|needsBracket|
	needsBracket := aDecoder node class = RBMessageNode.
	needsBracket ifTrue: [ self put: '(' ].
	(self child: aDecoder)
		isExpression: self isExpression;
		transpile.
	needsBracket ifTrue: [ self put: ')' ].

]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> transpileChildren [
	self children do: [ :child |
		self transpileChild: child
	].

]
