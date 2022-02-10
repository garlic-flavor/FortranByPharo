"
I transpile a method of Pharo class.
"
Class {
	#name : #SWMethodBodyTranspiler,
	#superclass : #SWDecoder,
	#instVars : [
		'stream',
		'messageNest',
		'generator'
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

{ #category : #accessing }
SWMethodBodyTranspiler class >> senderTranspilerClass [
	^ SWSenderTranspiler
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> << anObject [
	anObject transpileUsing: self

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> cr [
	self stream putLine
]

{ #category : #'code generation - protected' }
SWMethodBodyTranspiler >> decIndent [
	self stream decIndent
]

{ #category : #'private - code generation' }
SWMethodBodyTranspiler >> decMessageNest [
	messageNest := messageNest - 1.
	0 < messageNest ifTrue: [ self put: ')' ].

]

{ #category : #accessing }
SWMethodBodyTranspiler >> generator [
	^ generator ifNil: [ generator := [ :transpiler | |m|
		m := transpiler method.

		transpiler locals do: [ :each | self putVariableDeclarationOf: each ].
		(transpiler classInfo isNotNil and: [ m methodClass isInstanceSide ]) ifTrue: [
			self putSelfDefinition
		].
		transpiler putSequence: m sourceNode body.
		(transpiler classInfo isNotNil and: [ m sourceNode lastIsReturn not]) ifTrue: [
			transpiler putReturnSelf
		]
	] ]
]

{ #category : #accessing }
SWMethodBodyTranspiler >> generator: anObject [

	generator := anObject
]

{ #category : #'code generation - protected' }
SWMethodBodyTranspiler >> incIndent [
	self stream incIndent
]

{ #category : #'private - code generation' }
SWMethodBodyTranspiler >> incMessageNest [
	messageNest := messageNest + 1.
	1 < messageNest ifTrue: [ self put: '(' ].
]

{ #category : #'private - code generation' }
SWMethodBodyTranspiler >> mangle: aName [
	^ self class mangleClass mangle: aName
]

{ #category : #accessing }
SWMethodBodyTranspiler >> messageNest [

	^ messageNest ifNil: [ messageNest := 0 ]
]

{ #category : #accessing }
SWMethodBodyTranspiler >> messageNest: anObject [

	messageNest := anObject
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
SWMethodBodyTranspiler >> putArguments: arguments [

	self
		put: '(';
		withoutMessageNestDo: [
			arguments do: [ :each |
				self << each
			] separatedBy: [
				self put: ', '
			]
		];
		put: ')'

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putArray: anArray [

	self put: '['.
	anArray do: [:each |
		self << each
	] separatedBy: [
		self put: ', '
	].
	self put: ']'.

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putAssignTo: key with: value [

	self
		<< key;
		put: ' = ';
		<< value

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putBlock: aBlockNode [

	self
		put: '{';
		putSequence: aBlockNode body;
		put: '}'
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putBlockAsExpression: aBlock [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putCascade: aRBCascadeNode [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putCharacter: c [
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
SWMethodBodyTranspiler >> putCode: code [
	^ self putCode: code with: {  }
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putCode: code with: anAssociationArray [
	"when a line in code ends with $\, the line continues to the next."
	|matcher leftPad escaped|

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
	aStream
		<< self receiverClass instanceSide name;
		<< self selector asCamelCase
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putIfFalse: aNode [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putIfTrue: aNode [
	^ self subclassResponsibility
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putIfTrueIfFalse: aNode [
	^ self subclassResponsibility
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putImport: anArray from: aSource [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putInteger: anInteger [
	self put: anInteger asString
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putLine: anObject [
	self stream putLine: anObject asString
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putMessage: aNode [
	self incMessageNest.
	self << (self senders at: aNode).
	self decMessageNest
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putMessage: aNode withReceiver: aRNode [
	|sender|
	sender := (self senders at: aNode) copy.
	sender node: (aNode copy
		receiver: aRNode
		yourself).
	self << sender
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putNew: aNode [
	^ self subclassResponsibility
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putOpBinary: aNode [
	self
		<< aNode receiver;
		put: ' ';
		put: aNode selector;
		put: ' ';
		<< (aNode arguments at: 1)

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putParameters: anArray [

	anArray do: [:each |
		self put: each asString
	] separatedBy: [
		self put: ', '
	]

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putReturn: value [
	
	^ self
		put: 'return ';
		withoutMessageNestDo: [
			self << value
		]
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putReturnSelf [
	self putStatement: (RBReturnNode value: (RBVariableNode named: 'self'))
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putSelf [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putSelfDefinition [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putSequence: aSequence [
	self withoutMessageNestDo: [
		aSequence statements do: [ :each |
			self putStatement: each
		]
	]
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putSequenceWithReturn: aSequence [
	self withoutMessageNestDo: [
		aSequence statements doWithIndex: [ :each :index |
			(index < aSequence statements size or: [ each class = RBReturnNode ]) ifTrue: [
				self putStatement: each
			] ifFalse: [
				self
					putReturn: each;
					putStatementDelimiter;
					cr
			]
		]
	]
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putStatement: aStatement [
	self
		<< aStatement;
		putStatementDelimiter;
		cr

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putStatementDelimiter [
	self stream putDelimiter
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putString: aString [
	self
		put: '"';
		put: aString;
		put: '"'.
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putSymbol: aByteSymbol [
	self stream
		put: '"';
		put: aByteSymbol asString;
		put: '"'
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putVariable: aVariableNode [

	aVariableNode name = #self ifTrue: [
		^ self putSelf
	].
	(self classInfo isNotNil and: [ self classInfo hasVariable: aVariableNode name ]) ifTrue: [
		self
			putSelf;
			putClassAccessor;
			put: '_'
	].
	self put: aVariableNode name

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putVariableDeclarationOf: aVariableInfo [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWMethodBodyTranspiler >> stream [

	^ stream ifNil: [
		stream := SWTranspilerStream new
			yourself
	]
]

{ #category : #accessing }
SWMethodBodyTranspiler >> stream: anObject [

	stream := anObject.

]

{ #category : #'public API' }
SWMethodBodyTranspiler >> transpile [
	self generator value: self.
	^ self stream contents
]

{ #category : #'private - code generation' }
SWMethodBodyTranspiler >> withoutMessageNestDo: aBlock [
	|nest|
	nest := messageNest.
	messageNest := 0.
	aBlock value.
	messageNest := nest
]
