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

{ #category : #'as yet unclassified' }
SWClassDefinitionTranspiler class >> methodDefinitionTranspilerClass [
	^ self subclassResponsibility 
]

{ #category : #api }
SWClassDefinitionTranspiler >> declareMethodAsBinaryOperator: aName [
	^ super declareMethodAsBinaryOperator: aName
"
	self error; flag: #toRewrite.
	^ self defineMethodAsBinaryOperator: aName as: [ :newT |
		newT
			senderGenerator: [ :t :node | t putOpBinary: node ];
			yourself
	]
"
]

{ #category : #api }
SWClassDefinitionTranspiler >> declareMethodAsCompareOperator: aName [
	^ super declareMethodAsCompareOperator: aName.
"
	self error; flag: #toRemove.
	^ self defineMethodAsCompareOperator: aName as: [ :newT |
		newT
			senderGenerator: [ :t :node | t putOpBinary: node ];
			yourself
	]
"
]

{ #category : #'as yet unclassified' }
SWClassDefinitionTranspiler >> defineMethodBody: aName as: anInitializer [
	self addDecoderInitializer: aName with: [ :decoder |
		decoder
			generator: 	anInitializer;
			yourself
	]
]

{ #category : #'as yet unclassified' }
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

{ #category : #testing }
SWClassDefinitionTranspiler >> isTranspiled [
	^ stream isNotNil
]

{ #category : #'as yet unclassified' }
SWClassDefinitionTranspiler >> putClassFooter [
	self stream
		put: '}';
		putLine
]

{ #category : #'as yet unclassified' }
SWClassDefinitionTranspiler >> putClassHeader [
	self stream
		put: 'class ';
		put: targetClass name;
		put: '{';
		putLine
]

{ #category : #'as yet unclassified' }
SWClassDefinitionTranspiler >> putMember [
	self slot do: [ :each |
		(each isNotNil and: [ each name isEmptyOrNil not ]) ifTrue: [
			self putMemberDeclarationOf: each
		]
	].
	self methods do: [ :each | self putMethodDefinition: each ].

]

{ #category : #'as yet unclassified' }
SWClassDefinitionTranspiler >> putMemberDeclarationOf: aVariableTypeInfo [
	^ self subclassResponsibility

]

{ #category : #'as yet unclassified' }
SWClassDefinitionTranspiler >> putMethodDefinition: aMBT [
	aMBT class methodDefinitionTranspilerClass new
		stream: self stream;
		bodyTranspiler: aMBT;
		transpile

]

{ #category : #accessing }
SWClassDefinitionTranspiler >> stream [

	^ stream ifNil: [ stream := SWTranspilerStream new ]
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

{ #category : #'as yet unclassified' }
SWClassDefinitionTranspiler >> transpileAsClassSide [

	self putMember

]

{ #category : #'as yet unclassified' }
SWClassDefinitionTranspiler >> transpileAsInstanceSide [

	self stream putComment: self targetClass comment.
	self putClassHeader.
	self stream incIndent.
	classSide ifNotNil: [
		classSide
			stream: self stream;
			transpileAsClassSide
	].
	
	self putMember.

	self stream decIndent.
	self putClassFooter.
]
