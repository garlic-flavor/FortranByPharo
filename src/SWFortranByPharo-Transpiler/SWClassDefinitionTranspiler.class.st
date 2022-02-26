"
I transpile a Pharo class.
"
Class {
	#name : #SWClassDefinitionTranspiler,
	#superclass : #SWClassBase,
	#instVars : [
		'classInfo',
		'predefinedSender',
		'stream'
	],
	#category : #'SWFortranByPharo-Transpiler-Common'
}

{ #category : #'as yet unclassified' }
SWClassDefinitionTranspiler class >> methodBodyTranspilerClass [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWClassDefinitionTranspiler class >> methodDefinitionTranspilerClass [
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

{ #category : #'public API' }
SWClassDefinitionTranspiler >> defineMethodBody: aName as: anInitializer [
	self halt; flag: #toRewrite.
	self addDecoderInitializer: aName with: [ :decoder |
		decoder
			generator: 	anInitializer;
			yourself
	]
]

{ #category : #accessing }
SWClassDefinitionTranspiler >> isTranspiled [

	^ classInfo isNotNil
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
	anExpression expression ifNil: [ ^ self ].
	self class methodDefinitionTranspilerClass new
		bodyTranspiler: (self class methodBodyTranspilerClass new
			expression: anExpression;
			pool: self pool;
			stream: self stream;
			yourself);
		transpile

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
