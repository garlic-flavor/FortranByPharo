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
		'isExpression'
	],
	#category : #'SWFortranByPharo-Transpiler-Common'
}

{ #category : #constants }
SWMethodBodyTranspiler class >> mangleClass [
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler class >> methodDefinitionTranspilerClass [ 
	^ self subclassResponsibility
]

{ #category : #'instance creation' }
SWMethodBodyTranspiler class >> new: decoder [
	^ self new
		decoder: decoder;
		yourself
]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler class >> poolClass [
	^ SWTranspilerPool
]

{ #category : #accessing }
SWMethodBodyTranspiler class >> senderTranspilerClass [
	self halt; flag: #toRewrite.
	^ SWSenderTranspiler
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> at: anObject [
	self halt.
]

{ #category : #accessing }
SWMethodBodyTranspiler >> atArray: anArrayNode [
	self putArrayHeader.
	self children do: [ :child |
		self transpileChild: child
	] separatedBy: [ self putArrayHeader ].
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
SWMethodBodyTranspiler >> atClosure: aBlockNode [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> atInteger: anInteger [
	self put: anInteger asString
]

{ #category : #accessing }
SWMethodBodyTranspiler >> atMessage: aMessageNode [

	(self pool predefinedSenderTranspiler: self expression senderInfo) ifNotNil: [ :predefined |
		predefined value: self
	] ifNil: [
		self putOrdinaryMessage
	].

]

{ #category : #accessing }
SWMethodBodyTranspiler >> atMethod: aMethodNode [
	self putBlock

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> atReturn: aReturnNode [
	self putReturnKeyword; put: ' '.
	(self child: self children first)
		isExpression: true;
		transpile
		
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> atSequence: aSequenceNode [
	self halt.
	self transpileChildrenWithDelimiter

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
SWMethodBodyTranspiler >> mangle [
	^ self class mangleClass mangle: self expression
]

{ #category : #accessing }
SWMethodBodyTranspiler >> method [
	^ self expression method
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

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putArray: anArray [
	self halt; flag: #toRewrite.

	self put: '['.
	anArray do: [:each |
		self << each
	] separatedBy: [
		self put: ', '
	].
	self put: ']'.

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

{ #category : #streaming }
SWMethodBodyTranspiler >> putBasenameOn: aStream [
	self halt; flag: #toRewrite.
	aStream
		<< self receiverClass instanceSide name;
		<< self selector asCamelCase
]

{ #category : #accessing }
SWMethodBodyTranspiler >> putBlock [
	|functionized|
	functionized := (self isExpression and: [ self node arguments isNotEmpty or: [ self node temporaries isNotEmpty ] ]).
	functionized ifTrue: [
		self put: 'function('.
		self node arguments do: [ :each |
			self put: '_'; put: each name
		] separatedBy: [ self put: ', ' ].
		self put: '){'; cr; incIndent.
	].
	self children allButLastDo: [ :child |
		(self child: child)
			putArgumentDeclaration
	].
	(self child: self children last)
		isExpression: (functionized not and: [ self isExpression ]);
		putSequence.
	functionized ifTrue: [
		self
			decIndent; put: '}()'
	]
	

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
SWMethodBodyTranspiler >> putClosure [
	|sequence|
	self put: 'function('.
	self node arguments do: [ :each |
		self put: '_'; put: each name
	] separatedBy: [ self put: ', ' ].
	self put: '){'; cr; incIndent.

	self children allButLastDo: [ :child |
		(self child: child)
			putArgumentDeclaration
	].
	sequence := self children last.
	sequence children allButLastDo: [ :child |
		self transpileChildAsNotExpression: child
	].
	self putReturnKeyword; put: ' '.
	self transpileChildAsExpression: sequence children last.
	self putStatementDelimiter; cr; decIndent; put: '}'
	

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

{ #category : #streaming }
SWMethodBodyTranspiler >> putFilenameOn: aStream [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putIfFalse: aNode [
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> putIfNotNilIfNil: strait [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putIfTrue [
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
SWMethodBodyTranspiler >> putNew [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> putNil [
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> putOnDo [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putOpBinary [
	self
		transpileChildWithBracket: self children first;
		put: ' ';
		put: self node selector;
		put: ' ';
		transpileChildWithBracket: self children second

]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> putOrdinaryMessage [
	self
		transpileChild: self children first;
		putClassAccessor;
		put: self mangle;
		putArguments: self children allButFirst

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
	self halt; flag: #toRewrite.
	self putStatement: (RBReturnNode value: (RBVariableNode named: 'self'))
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putSelf [
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
				isExpression: false;
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
SWMethodBodyTranspiler >> putSequenceWithReturn: aSequence [
	self error; flag: #toRemove.
	self withoutMessageNestDo: [
		aSequence statements doWithIndex: [ :each :index |
			((aSequence isLast: each) and: [ each class ~= RBReturnNode ]) ifTrue: [
				self
					node:each;
					atReturn: self decoder;
					putReturn: each;
					putStatementDelimiter;
					cr
			] ifFalse: [
				self putStatement: each
			]
		]
	]
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putStatementDelimiter [
	self stream putDelimiter
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putSymbol: aByteSymbol [
	self halt; flag: #toRewrite.
	self stream
		put: '"';
		put: aByteSymbol asString;
		put: '"'
]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> putVariable [
	self expression slot detect: [ :each | each name = self node name ] ifFound: [
		self put: '_'
	].
	self put: self node name
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putVariableDeclaration [
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> putYourself [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWMethodBodyTranspiler >> receiverClass [
	self error; flag: #toRemove.
	^ self decoder receiverClass
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

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> transpileChildrenWithDelimiter [
	self error; flag: #toRemove.
	self isExpression ifTrue: [
		1 < self children size ifTrue: [ self put: '(' ].
		self children do: [ :child |
			self transpileChild: child
		] separatedBy: [
			self put: ', '; cr
		].
		1 < self children size ifTrue: [ self put: ')' ].
	] ifFalse: [
		self children do: [ :child |
			self
				transpileChild: child;
				putStatementDelimiter;
				cr
		].
	]

]
