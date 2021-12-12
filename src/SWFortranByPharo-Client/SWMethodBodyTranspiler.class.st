"
I transpile a method of Pharo class.
"
Class {
	#name : #SWMethodBodyTranspiler,
	#superclass : #SWStackAnalyzer,
	#instVars : [
		'stream',
		'type',
		'messageNest'
	],
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #utils }
SWMethodBodyTranspiler class >> messageTranspilerMethodNameFor: aSelector [
	^ ((self safeSelectorNameOf: aSelector), 'For:With:') asSymbol
]

{ #category : #utils }
SWMethodBodyTranspiler class >> uniqueMessageTranspilerNameFor: aSelector for: type [
	^ (String streamContents: [ :s |
		s << type; <<  '_'; << (self safeSelectorNameOf: aSelector); << 'With:Using:'
	]) asSymbol
	

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> << anObject [
	self stream log.
	anObject transpileUsing: self

]

{ #category : #'private - utilities' }
SWMethodBodyTranspiler >> classOf: aNode [
	aNode class = RBVariableNode ifTrue: [
		^ aNode name first isUppercase ifTrue: [
			(Smalltalk globals at: aNode name asSymbol) class
		] ifFalse: [
			(self variableInfoOf: aNode name) type
		]
	].

	aNode class = RBLiteralValueNode ifTrue: [
		^ aNode value class
	].

	self error: 'to implement'.
	self flag: #toImplement.
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> cr [
	self stream putLine
]

{ #category : #'private - code generation' }
SWMethodBodyTranspiler >> decMessageNest [
	messageNest push: { 0. messageNest pop - 1 } max.
	0 < messageNest top ifTrue: [ self put: ')' ].

]

{ #category : #'private - testing' }
SWMethodBodyTranspiler >> hasOwnMessageTranspilerMethodOf: aSelector ifTrue: aBlock [
	|otms aMethod|
	otms := self class messageTranspilerMethodNameFor: aSelector.
	(aMethod := self class search: otms in: self class) ifNotNil: [
		aBlock value: [ :receiver :arguments |
			aMethod valueWithReceiver: self arguments: { receiver. arguments }
		]
	]

]

{ #category : #'private - testing' }
SWMethodBodyTranspiler >> ifUniqueMessageTranspilerExistsOn: receiver of: selector thenDo: aBlock [
	| receiverClassClass selectorName transpiler |

	receiverClassClass := self metaclassOf: receiver.
	selectorName := self class uniqueMessageTranspilerNameFor: selector for: self type.
	(transpiler := self class search: selectorName in: receiverClassClass) ifNotNil: [
		aBlock value: [ :arguments |
			transpiler valueWithReceiver: receiverClassClass arguments: { arguments. self }
		]
	].

]

{ #category : #'private - code generation' }
SWMethodBodyTranspiler >> incMessageNest [
	messageNest push: (messageNest pop + 1).
	1 < messageNest top ifTrue: [ self put: '(' ].
]

{ #category : #initialization }
SWMethodBodyTranspiler >> initialize [
	super initialize.
	messageNest := Stack newFrom: { 0 }.
]

{ #category : #'public API' }
SWMethodBodyTranspiler >> logging: trueOrFalse [
	self stream logging: trueOrFalse
]

{ #category : #'private - utilities' }
SWMethodBodyTranspiler >> metaclassOf: receiver [
	|rType|
	^ (rType := (self classOf: receiver))  class = Metaclass ifTrue: [
		rType
	] ifFalse: [
		rType class
	]
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> opEqual_For: receiver With: arguments [
	self stream log: [ receiver asString, ' == ', (arguments at: 1) asString ].
	self
		<< receiver;
		put: ' == ';
		<< (arguments at: 1).

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> put: anObject [
	self stream put: anObject asString
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putArguments: arguments [
	self stream log.
	self put: '('.
	arguments do: [ :each |
		self << each
	] separatedBy: [
		self put: ', '
	].
	self put: ')'

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putArray: anArray [
	self stream log.
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
	self stream log: [ key asString, ' = ', value asString ].
	self
		<< key;
		put: ' = ';
		<< value

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putCascade: aRBCascadeNode [
	({ RBVariableNode. RBLiteralValueNode } anySatisfy: [ :each | each = aRBCascadeNode leftmostChainReceiver class ]) ifTrue: [
		aRBCascadeNode messages do: [ :msgNode |
			self putStatement: msgNode
		]
	] ifFalse: [|tmp|
		tmp := RBVariableNode new
			name: self tempStore pop name;
			yourself.
		self
			putAssignTo: tmp with: aRBCascadeNode leftmostChainReceiver;
			putStatementDelimiter;
			cr.
		aRBCascadeNode messages do: [ :msgNode | 
			self
				putMessage: msgNode withReceiver: tmp;
				putStatementDelimiter;
				cr
		]
	]

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putCharacter: c [
	self stream log.

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
	self stream log.

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
SWMethodBodyTranspiler >> putInteger: anInteger [
	self stream log.
	self put: anInteger asString
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putMessage: aNode withReceiver: aRNode [
	self stream log: [ aNode receiver asString, ' >> ', aNode selector asString ].
	self incMessageNest.
	self selectTranspiler: aNode withReceiver: aRNode.
	self decMessageNest
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putOrdinaryMessage: aNode withReceiver: aRNode [
	self stream log.
	self << aRNode.
	aNode selector first isLetter ifTrue: [
		self
			putClassAccessor;
			put: (self sends at: aNode) mangledName;
			putArguments: aNode arguments.
	] ifFalse: [
		self
			put: aNode selector;
			<< (aNode arguments at: 1)
	]


]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putParameters: anArray [
	self stream log.
	anArray do: [:each |
		self put: each asString
	] separatedBy: [
		self put: ', '
	]

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putReturn: value [
	self stream log.
	^ self
		put: 'return ';
		<< value.
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putSequence: aSequence [
	aSequence statements do: [ :each |
		self putStatement: each
	]
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putStatement: aStatement [
	self << aStatement.
	aStatement class = RBCascadeNode ifTrue: [ ^ self ].
	self
		putStatementDelimiter;
		cr

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putStatementDelimiter [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putString: aString [
	self stream log.
	self
		put: '"';
		put: aString;
		put: '"'.
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putVariable: aVariableNode [
	self stream log: aVariableNode name.
	self put: aVariableNode name
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putVariableDeclarationOf: aVariableInfo [
	^ self subclassResponsibility 
]

{ #category : #'private - code generation' }
SWMethodBodyTranspiler >> selectTranspiler: aNode withReceiver: aRNode [
	self stream log: [ aNode receiver asString, ' >> ', aNode selector asString ].
	self ifUniqueMessageTranspilerExistsOn: aRNode of: aNode selector thenDo: [ :proc |
		^ proc value: aNode arguments
	].
	self hasOwnMessageTranspilerMethodOf: aNode selector ifTrue: [ :proc |
		^ proc with: aRNode with: aNode arguments
	].
	^ self putOrdinaryMessage: aNode withReceiver: aRNode

]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspiler >> solveDependencies [
	^ (self dependencies groupedBy: [ :each | each method methodClass ]) collect: [ :each |
		
	]
]

{ #category : #accessing }
SWMethodBodyTranspiler >> stream [

	^ stream ifNil: [ stream := SWTranspilerStream new ]
]

{ #category : #accessing }
SWMethodBodyTranspiler >> stream: anObject [

	stream := anObject
]

{ #category : #'public API' }
SWMethodBodyTranspiler >> transpile [
	self stream log.
	self ready ifFalse: [ ^ Exception signal: 'something go wrong.' ].
	self locals do: [ :each | self putVariableDeclarationOf: each ].
	self putSequence: self method sourceNode body.
	^ self stream contents
]

{ #category : #accessing }
SWMethodBodyTranspiler >> type [

	^ type
]

{ #category : #accessing }
SWMethodBodyTranspiler >> type: anObject [

	type := anObject
]
