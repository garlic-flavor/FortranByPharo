"
I transpile a Pharo class.
"
Class {
	#name : #SWClassDefinitionTranspiler,
	#superclass : #SWClassBase,
	#instVars : [
		'stream',
		'isTranspiled',
		'predefinedSender'
	],
	#category : #'SWFortranByPharo-Transpiler-Common'
}

{ #category : #accessing }
SWClassDefinitionTranspiler class >> methodDefinitionTranspilerClass [
	^ self subclassResponsibility 
]

{ #category : #api }
SWClassDefinitionTranspiler >> declareMethodAsCompareOperator: aName [
	self halt; flag: #toRewrite.
	super declareMethodAsCompareOperator: aName.
	self defineMethodSender: aName as: [ :transpiler :sender |
		transpiler putOpBinary: sender node
	]
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

{ #category : #'public API' }
SWClassDefinitionTranspiler >> defineMethodSender: aName as: aGenerator [
	self halt; flag: #toRewrite.
	self addSenderInitializer: aName with: [ :sender |
		sender
			generator: aGenerator;
			yourself
	]
]

{ #category : #initialization }
SWClassDefinitionTranspiler >> initialize_Number [
	self halt; flag: #toRewrite.
	super initialize_Number.
	self
		defineMethodSender: #+ as: [ :transpiler :sender | transpiler putOpBinary: sender node ];
		defineMethodSender: #- as: [ :transpiler :sender | transpiler putOpBinary: sender node ];
		defineMethodSender: #* as: [ :transpiler :sender | transpiler putOpBinary: sender node ];
		defineMethodSender: #/ as: [ :transpiler :sender | transpiler putOpBinary: sender node ]
]

{ #category : #initialization }
SWClassDefinitionTranspiler >> initialize_ProtoObject [
	self halt; flag: #toRewrite.
	super initialize_ProtoObject.
	self
		defineMethodSender: #flag: as: [ :transpiler :sender |
			transpiler preventStatementDelimiter; preventNewline
		]
]

{ #category : #initialization }
SWClassDefinitionTranspiler >> initialize_TestCaseClass [
	self halt; flag: #toRewrite.
	super initialize_TestCaseClass.
	self
		defineMethodBody: #allTestSelectors as: [ :transpiler |
			transpiler putStatement: (RBReturnNode value: (RBLiteralArrayNode value: (
				transpiler receiverClass instanceSide methodDict keys select: [ :each |
					each beginsWith: 'test'
				] thenCollect: [ :each |
					RBLiteralValueNode value: each
				])))
		]

]

{ #category : #testing }
SWClassDefinitionTranspiler >> isTranspiled [
	self halt; flag: #toRewrite.
	^ isTranspiled ifNil: [ isTranspiled := false ]
]

{ #category : #'as yet unclassified' }
SWClassDefinitionTranspiler >> markAsNotTranspiled [
	self halt; flag: #toRewrite.
	isTranspiled := false
]

{ #category : #'as yet unclassified' }
SWClassDefinitionTranspiler >> markAsTranspiled [
	self halt; flag: #toRewrite.
	isTranspiled := true
]

{ #category : #'instance creation' }
SWClassDefinitionTranspiler >> newDecoderOf: aMethod with: args [
	self halt; flag: #toRewrite.
	^ (super newDecoderOf: aMethod with: args)
		stream: self stream;
		yourself
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
	self halt; flag: #toRewrite.
	self stream
		put: '}';
		putLine
]

{ #category : #'code generation' }
SWClassDefinitionTranspiler >> putClassHeader [
	self halt; flag: #toRewrite.
	self stream
		put: 'class ';
		put: targetClass name;
		put: '{';
		putLine
]

{ #category : #'code generation' }
SWClassDefinitionTranspiler >> putMember [
	self halt; flag: #toRewrite.
	self slot do: [ :each |
		(each isNotNil and: [ each name isEmptyOrNil not ]) ifTrue: [
			self putMemberDeclarationOf: each
		]
	].
	self methods do: [ :each | self putMethodDefinition: each ].

]

{ #category : #'code generation' }
SWClassDefinitionTranspiler >> putMemberDeclarationOf: aVariableTypeInfo [
	self halt; flag: #toRewrite.
	^ self subclassResponsibility

]

{ #category : #'code generation' }
SWClassDefinitionTranspiler >> putMethodDefinition: aMBT [
	self halt; flag: #toRewrite.
	aMBT ifNil: [ ^ self ].
	aMBT class methodDefinitionTranspilerClass new
		bodyTranspiler: aMBT;
		transpile

]

{ #category : #'as yet unclassified' }
SWClassDefinitionTranspiler >> senderTranspilerOf: aSelector is: initializer [
	self predefinedSender at: aSelector put: initializer
]

{ #category : #accessing }
SWClassDefinitionTranspiler >> stream [
	self halt; flag: #toRewrite.

	^ stream ifNil: [ stream := self pool owner stream ]
]

{ #category : #accessing }
SWClassDefinitionTranspiler >> stream: anObject [
	self halt; flag: #toRewrite.

	stream := anObject
]

{ #category : #'public API' }
SWClassDefinitionTranspiler >> transpile [
	self halt; flag: #toRewrite.
	self targetClass isInstanceSide ifTrue: [
		self transpileAsInstanceSide
	] ifFalse: [
		self transpileAsClassSide
	].
	self markAsTranspiled

]

{ #category : #private }
SWClassDefinitionTranspiler >> transpileAsClassSide [
	self halt; flag: #toRewrite.

	self putMember

]

{ #category : #private }
SWClassDefinitionTranspiler >> transpileAsInstanceSide [
	self halt; flag: #toRewrite.
"
	self stream putComment: self targetClass comment.
	self putClassHeader.
	self stream incIndent.
	classSide ifNotNil: [
		classSide transpileAsClassSide
	].
	
	self putMember.

	self stream decIndent.
	self putClassFooter.
"
]
