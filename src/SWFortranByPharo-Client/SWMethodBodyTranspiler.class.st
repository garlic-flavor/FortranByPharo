"
I transpile a method of Pharo class.
"
Class {
	#name : #SWMethodBodyTranspiler,
	#superclass : #SWStackAnalyzerToTranspile,
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
		s << type; <<  '_'; << (self safeSelectorNameOf: aSelector); << 'For:With:Using:'
	]) asSymbol
	

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> << anObject [
	self stream log.
	anObject transpileUsing: self

]

{ #category : #'private - utilities' }
SWMethodBodyTranspiler >> classOf: receiver [

	receiver class = RBLiteralValueNode ifTrue: [
		^ receiver value class
	].

	receiver class = RBVariableNode ifTrue: [
		^ receiver name first isUppercase ifTrue: [
			(Smalltalk globals at: receiver name)
		] ifFalse: [
			(self variableInfoOf: receiver name) type
		]
	].

	self halt.
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
	|seq tmp|
	tmp := RBVariableNode new
		name: self tempStore pop name;
		yourself.
	seq := RBSequenceNode new
		addNode: (RBAssignmentNode variable: tmp value: aRBCascadeNode leftmostChainReceiver );
		addNodes: (aRBCascadeNode messages collect: [:each |
			each copy
				receiver: tmp;
				yourself
		]);
		yourself.
	self putSequence: seq.

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
SWMethodBodyTranspiler >> putMessage: receiver send: selector with: arguments [
	self stream log: [ receiver asString, ' >> ', selector asString ].
	self incMessageNest.
	self selectTranspilerFor: receiver send: selector with: arguments.
	self decMessageNest
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putOrdinaryMessage: receiver send: selector with: arguments [
	self stream log.
	self << receiver.
	selector first isLetter ifTrue: [
		self
			putClassAccessor;
			put: (self class safeSelectorNameOf: selector);
			putArguments: arguments.
	] ifFalse: [
		self
			put: selector;
			<< (arguments at: 1)
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
SWMethodBodyTranspiler >> selectTranspilerFor: receiver send: selector with: arguments [
	self stream log: [ receiver asString, ' >> ', selector asString ].
	self ifUniqueMessageTranspilerExistsOn: receiver of: selector thenDo: [ :proc |
		^ proc value: arguments
	].
	self hasOwnMessageTranspilerMethodOf: selector ifTrue: [ :proc |
		^ proc with: receiver with: arguments
	].
	^ self putOrdinaryMessage: receiver send: selector with: arguments

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
