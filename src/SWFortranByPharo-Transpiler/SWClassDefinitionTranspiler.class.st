"
I transpile a Pharo class.
"
Class {
	#name : #SWClassDefinitionTranspiler,
	#superclass : #SWClassBase,
	#instVars : [
		'decoder',
		'predefinedSender'
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

{ #category : #adding }
SWClassDefinitionTranspiler >> addSlotAbout: aClass [
	self error; flag: #toRemove.
	"
	aClass ifNil: [ ^ self ].
	aClass slots do: [ :item |
		slot push name: item name
	].
	aClass classVarNames do: [ :item |
		slot push name: item
	].
	self addSlotAbout: aClass superclass
"
]

{ #category : #accessing }
SWClassDefinitionTranspiler >> decoder [

	^ decoder
]

{ #category : #accessing }
SWClassDefinitionTranspiler >> decoder: anObject [

	decoder := anObject
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

{ #category : #accessing }
SWClassDefinitionTranspiler >> haltList [
	self error; flag: #toRemove.
	^ self pool haltList
]

{ #category : #accessing }
SWClassDefinitionTranspiler >> isTranspiled [

	^ decoder isNotNil
]

{ #category : #accessing }
SWClassDefinitionTranspiler >> logger [
	self error; flag: #toRemove.
	^ self pool logger
]

{ #category : #accessing }
SWClassDefinitionTranspiler >> methodBodyProcedureClass [
	self error; flag: #toRemove.
	^ self pool methodBodyProcedureClass
]

{ #category : #accessing }
SWClassDefinitionTranspiler >> methods [
	self error; flag: #toRemove.
	
	"A Set object consists of referenced methods."
"
	^ methods ifNil: [methods := Dictionary new ]
"
]

{ #category : #accessing }
SWClassDefinitionTranspiler >> methods: anObject [
self error; flag: #toRemove.
"
	methods := anObject
"
]

{ #category : #'instance creation' }
SWClassDefinitionTranspiler >> newDecoderOf: aMethod with: args [
	self halt; flag: #toRewrite.
	^ (super newDecoderOf: aMethod with: args)
		stream: self stream;
		yourself
]

{ #category : #'instance creation' }
SWClassDefinitionTranspiler >> newMethodBodyProcedure: aSender [
self error; flag: #toRemove.
	^ self methodBodyProcedureClass new
		logger: self logger;
		haltList: self haltList;
		pool: self pool;
		slot: self slot copy;
		method: aSender method;
		operands: aSender operands;
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
		self decoder slot detect: [ :one | one name = each name ] ifFound: [ :found |
			(found isNotNil and: [ found name isEmptyOrNil not ]) ifTrue: [
				self putMemberDeclarationOf: found
			]
		]
	].
	self decoder methods do: [ :each | self putMethodDefinition: each ].

]

{ #category : #'code generation' }
SWClassDefinitionTranspiler >> putMemberDeclarationOf: aVariableTypeInfo [
	^ self subclassResponsibility

]

{ #category : #'code generation' }
SWClassDefinitionTranspiler >> putMethodDefinition: aDecoder [
	aDecoder class = SWDecoder ifFalse: [ ^ self ].
	self class methodDefinitionTranspilerClass new
		bodyTranspiler: (self class methodBodyTranspilerClass new
			decoder: aDecoder;
			stream: self stream;
			yourself);
		transpile

]

{ #category : #'as yet unclassified' }
SWClassDefinitionTranspiler >> senderTranspilerOf: aSelector is: initializer [
	self predefinedSender at: aSelector put: initializer
]

{ #category : #api }
SWClassDefinitionTranspiler >> setBreakpointOn: aName [
	self error; flag: #toRemove.
	"
	self addPredefined: aName with: [ :operands |
		self halt.
	]
"
]

{ #category : #accessing }
SWClassDefinitionTranspiler >> slot [
	self error; flag: #toRemove.
	"
	^ slot ifNil: [
		slot := SWSlot new.
		self addSlotAbout: self targetClass.
		slot
	]
"
]

{ #category : #accessing }
SWClassDefinitionTranspiler >> slot: anObject [
self error; flag: #toRemove.
"
	slot := anObject
"
]

{ #category : #accessing }
SWClassDefinitionTranspiler >> stream [
	^ self pool owner stream
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
	(self pool getClassProcedure: targetClass classSide)
		transpileAsClassSide.
	self putMember.
	self stream decIndent.
	self putClassFooter.

]
