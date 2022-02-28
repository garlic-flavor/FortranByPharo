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

{ #category : #constants }
SWClassDefinitionTranspiler class >> mangleClass [
	^ self methodBodyTranspilerClass mangleClass
]

{ #category : #'as yet unclassified' }
SWClassDefinitionTranspiler class >> methodBodyTranspilerClass [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWClassDefinitionTranspiler >> classInfo [

	^ classInfo
]

{ #category : #accessing }
SWClassDefinitionTranspiler >> classInfo: anObject [

	classInfo := anObject
]

{ #category : #accessing }
SWClassDefinitionTranspiler >> isTranspiled [

	^ isTranspiled ifNil: [ isTranspiled := false ]
]

{ #category : #'as yet unclassified' }
SWClassDefinitionTranspiler >> markAsTranspiled [
	isTranspiled := true
]

{ #category : #'public API' }
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

{ #category : #'as yet unclassified' }
SWClassDefinitionTranspiler >> predefinedMethodBodyTranspiler: aSelector [
	^ self predefinedBody at: aSelector ifAbsent: [ nil ]
]

{ #category : #accessing }
SWClassDefinitionTranspiler >> predefinedSender [

	^ predefinedSender ifNil: [ predefinedSender := Dictionary new ]
]

{ #category : #accessing }
SWClassDefinitionTranspiler >> predefinedSender: anObject [

	predefinedSender := anObject
]

{ #category : #'as yet unclassified' }
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
	self stream
		put: 'class ';
		put: targetClass name;
		put: '{';
		putLine
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
	self classInfo methods do: [ :each | self putMethodDefinition: each ].

]

{ #category : #'code generation' }
SWClassDefinitionTranspiler >> putMemberDeclarationOf: aVariable [
	^ self subclassResponsibility

]

{ #category : #'code generation' }
SWClassDefinitionTranspiler >> putMethodDefinition: anExpression [
	anExpression expression ifNil: [ ^ self putPredefinedMethodBody: anExpression messageInfo ].
	self putMethodHeader: anExpression.
	self class methodBodyTranspilerClass new
		expression: anExpression;
		pool: self pool;
		stream: self stream;
		transpile.
	self putMethodFooter: anExpression

]

{ #category : #'as yet unclassified' }
SWClassDefinitionTranspiler >> putMethodFooter: anExpression [
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SWClassDefinitionTranspiler >> putMethodHeader: anExpression [
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SWClassDefinitionTranspiler >> putPredefinedMethodBody: aMessageInfo [
	aMessageInfo ifNil: [ ^ self ].
	(self predefinedMethodBodyTranspiler: aMessageInfo method selector) ifNotNil: [ :predef ||exp|
		exp := SWExpression new
				pool: self pool;
				node: aMessageInfo method sourceNode;
				messageInfo: aMessageInfo;
				slot: self classInfo slot copy;
				readySlot;
				yourself.
		self putMethodHeader: exp.
		predef cull: (self class methodBodyTranspilerClass new
			expression: exp;
			pool: self pool;
			pool: self pool;
			yourself).
		self putMethodFooter: exp
	]

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

{ #category : #'public API' }
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
	self pool transpile: targetClass classSide.
	self putMember.
	self stream decIndent.
	self putClassFooter.

]
