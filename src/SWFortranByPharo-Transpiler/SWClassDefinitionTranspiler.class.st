"
I transpile a Pharo class.
"
Class {
	#name : #SWClassDefinitionTranspiler,
	#superclass : #SWClassBase,
	#instVars : [
		'classInfo',
		'predefinedSender',
		'predefinedBody',
		'stream',
		'isTranspiled'
	],
	#category : #'SWFortranByPharo-Transpiler-Common'
}

{ #category : #accessing }
SWClassDefinitionTranspiler >> classInfo [

	^ classInfo
]

{ #category : #accessing }
SWClassDefinitionTranspiler >> classInfo: anObject [

	classInfo := anObject
]

{ #category : #private }
SWClassDefinitionTranspiler >> detectPredefinedMethodBodyFor: anExpression ifFound: foundBlock ifNone: noneBlock [
	|method|
	method := anExpression senderInfo method.
	method ifNil: [ ^ noneBlock value ].
	self predefinedBody at: method selector ifPresent: [ :pre |
		foundBlock cull: pre
	] ifAbsent: [
		noneBlock value.
	]
]

{ #category : #accessing }
SWClassDefinitionTranspiler >> isTranspiled [

	^ isTranspiled ifNil: [ isTranspiled := false ]
]

{ #category : #constants }
SWClassDefinitionTranspiler >> mangleClass [
	^ self pool class mangleClass
]

{ #category : #modifying }
SWClassDefinitionTranspiler >> markAsTranspiled [
	isTranspiled := true
]

{ #category : #constants }
SWClassDefinitionTranspiler >> methodBodyTranspilerClass [
	^ self pool class methodBodyTranspilerClass
]

{ #category : #api }
SWClassDefinitionTranspiler >> methodBodyTranspilerOf: aName is: transpiler [
	self predefinedBody at: aName put: transpiler
]

{ #category : #accessing }
SWClassDefinitionTranspiler >> predefinedBody [

	^ predefinedBody ifNil: [ predefinedBody := Dictionary new ]
]

{ #category : #accessing }
SWClassDefinitionTranspiler >> predefinedBody: anObject [

	predefinedBody := anObject
]

{ #category : #accessing }
SWClassDefinitionTranspiler >> predefinedSender [

	^ predefinedSender ifNil: [ predefinedSender := Dictionary new ]
]

{ #category : #accessing }
SWClassDefinitionTranspiler >> predefinedSender: anObject [

	predefinedSender := anObject
]

{ #category : #accessing }
SWClassDefinitionTranspiler >> predefinedSenderTranspiler: aSelector [
	^ self predefinedSender at: aSelector ifAbsent: [ nil ]

]

{ #category : #'code generation' }
SWClassDefinitionTranspiler >> putClassFooter [
	self stream
		put: '}';
		putLine
]

{ #category : #'code generation' }
SWClassDefinitionTranspiler >> putClassHeader [
	^ self subclassResponsibility 

]

{ #category : #'code generation' }
SWClassDefinitionTranspiler >> putMember [
	self targetClass slots do: [ :each |
		self classInfo slot detect: [ :one | one name = each name ] ifFound: [ :found |
			(found isNotNil and: [ found name isEmptyOrNil not ]) ifTrue: [
				self putMemberDeclarationOf: found
			]
		]
	].
	self putMethods.
]

{ #category : #'code generation' }
SWClassDefinitionTranspiler >> putMemberDeclarationOf: aVariable [
	^ self subclassResponsibility

]

{ #category : #'code generation' }
SWClassDefinitionTranspiler >> putMethodDefinition: anExpression [
	|exp mbt|
	exp := anExpression expression ifNil: [ 
		SWExpression new
			pool: self pool;
			node: anExpression messageInfo method sourceNode;
			messageInfo: anExpression messageInfo;
			slot: self classInfo slot copy;
			readySlot;
			yourself.
	].

	mbt := self methodBodyTranspilerClass new
		pool: self pool;
		stream: self stream;
		expression: exp;
		isExpression: true;
		yourself.

	self putMethodHeader: mbt.
	self detectPredefinedMethodBodyFor: anExpression ifFound: [ :pre|
		mbt putArgumentDeclaration: mbt expression arguments;
			put: '{'; cr; incIndent.
		pre cull: mbt.
		mbt decIndent; put: '}'; cr
	] ifNone: [ 
		mbt transpile
	].
	self putMethodFooter: mbt.


]

{ #category : #'code generation' }
SWClassDefinitionTranspiler >> putMethodFooter: methodBodyTranspiler [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWClassDefinitionTranspiler >> putMethodHeader: methodBodyTranspiler [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWClassDefinitionTranspiler >> putMethods [
	self classInfo methods do: [ :each | self putMethodDefinition: each ].

]

{ #category : #api }
SWClassDefinitionTranspiler >> senderTranspilerOf: aSelector is: initializer [
	self predefinedSender at: aSelector put: initializer
]

{ #category : #accessing }
SWClassDefinitionTranspiler >> stream [
	^ stream ifNil: [ stream := self pool stream ]
]

{ #category : #accessing }
SWClassDefinitionTranspiler >> stream: anObject [

	stream := anObject
]

{ #category : #api }
SWClassDefinitionTranspiler >> transpile [
	self markAsTranspiled.
	self targetClass isInstanceSide ifTrue: [
		self transpileAsInstanceSide
	] ifFalse: [
		self transpileAsClassSide
	].

]

{ #category : #private }
SWClassDefinitionTranspiler >> transpileAsClassSide [
	self putMember

]

{ #category : #private }
SWClassDefinitionTranspiler >> transpileAsInstanceSide [
	self stream putComment: self targetClass comment.
	self putClassHeader.
	self stream incIndent.
	(self pool getClassInfo: targetClass classSide)
		transpile.
	self putMember.
	self stream decIndent.
	self putClassFooter.

]
