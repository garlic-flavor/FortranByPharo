"
I transpile a Pharo class.
"
Class {
	#name : #SWClassDefinitionTranspiler,
	#superclass : #SWClass,
	#instVars : [
		'stream'
	],
	#category : #'SWFortranByPharo-Transpiler-Common'
}

{ #category : #accessing }
SWClassDefinitionTranspiler class >> methodDefinitionTranspilerClass [
	^ self subclassResponsibility 
]

{ #category : #'public API' }
SWClassDefinitionTranspiler >> defineMethodBody: aName as: anInitializer [
	self addDecoderInitializer: aName with: [ :decoder |
		decoder
			generator: 	anInitializer;
			yourself
	]
]

{ #category : #'public API' }
SWClassDefinitionTranspiler >> defineMethodSender: aName as: aGenerator [
	self addSenderInitializer: aName with: [ :sender |
		sender
			generator: aGenerator;
			yourself
	]
]

{ #category : #initialization }
SWClassDefinitionTranspiler >> initialize_Number [
	super initialize_Number.
	self
		defineMethodSender: #+ as: [ :transpiler :node | transpiler putOpBinary: node ];
		defineMethodSender: #- as: [ :transpiler :node | transpiler putOpBinary: node ];
		defineMethodSender: #* as: [ :transpiler :node | transpiler putOpBinary: node ];
		defineMethodSender: #/ as: [ :transpiler :node | transpiler putOpBinary: node ]
]

{ #category : #initialization }
SWClassDefinitionTranspiler >> initialize_TestCaseClass [
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
	^ stream isNotNil or: [ stream isEmpty ]
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
	self slot do: [ :each |
		(each isNotNil and: [ each name isEmptyOrNil not ]) ifTrue: [
			self putMemberDeclarationOf: each
		]
	].
	self methods do: [ :each | self putMethodDefinition: each ].

]

{ #category : #'code generation' }
SWClassDefinitionTranspiler >> putMemberDeclarationOf: aVariableTypeInfo [
	^ self subclassResponsibility

]

{ #category : #'code generation' }
SWClassDefinitionTranspiler >> putMethodDefinition: aMBT [
	aMBT ifNil: [ ^ self ].
	aMBT class methodDefinitionTranspilerClass new
		bodyTranspiler: aMBT;
		transpile

]

{ #category : #accessing }
SWClassDefinitionTranspiler >> stream [

	^ stream ifNil: [ stream := self pool owner stream ]
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
	]
	

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
	classSide ifNotNil: [
		classSide transpileAsClassSide
	].
	
	self putMember.

	self stream decIndent.
	self putClassFooter.
]
