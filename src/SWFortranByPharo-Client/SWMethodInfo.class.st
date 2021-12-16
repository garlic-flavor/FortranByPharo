"
I have informations about Pharo's method to transpile.
I'm designed as very lazy to avoid problems like circular referencing of methods.

"
Class {
	#name : #SWMethodInfo,
	#superclass : #SymbolicBytecodeBuilder,
	#instVars : [
		'mangledName',
		'stack',
		'return',
		'sourceHash',
		'classInfo',
		'numTemps',
		'messages',
		'pool'
	],
	#category : #'SWFortranByPharo-Client-Analyzer'
}

{ #category : #'instance creation' }
SWMethodInfo class >> new: aMethodOrSelector with: anArrayOfVariableInfoOrTypes [
	^ self new
		method: aMethodOrSelector;
		types: anArrayOfVariableInfoOrTypes;
		yourself

]

{ #category : #'instance creation' }
SWMethodInfo class >> newDefaultPool [
	^ SWPool new
		transpilerClass: self;
		yourself
]

{ #category : #utils }
SWMethodInfo class >> safeSelectorNameOf: selector [
	selector = '=' ifTrue: [ ^ 'opEqual_' ].
	selector = '==' ifTrue: [ ^ 'opEqual_' ].
	selector = '~=' ifTrue: [ ^ 'opNotEqual_' ].
	selector = ',' ifTrue: [ ^ 'opCamma_' ].
	selector = '->' ifTrue: [ ^ 'opArrow_' ].
	selector = '/' ifTrue: [ ^ 'opDiv_' ].
	selector = '<<' ifTrue: [ ^ 'opWrite_' ].
	selector = '+' ifTrue: [ ^ 'opPlus_' ].
	selector = '<' ifTrue: [ ^ 'opLT_' ].
	selector = '*' ifTrue: [ ^ 'opMul_' ].
	selector = '-' ifTrue: [ ^ 'opSub_' ].
	^ selector collect: [:c | (#' >#:/' anySatisfy: [ :each | each = c]) ifTrue: [ $_ ] ifFalse: [ c ] ]

]

{ #category : #utils }
SWMethodInfo class >> search: selector in: aClass [
	^ aClass ifNil: [
		nil
	] ifNotNil: [
		aClass methodDict at: selector ifAbsent: [
			self search: selector in: aClass superclass
		]
	]
]

{ #category : #comparing }
SWMethodInfo >> = right [
	self method = right method ifFalse: [ ^ false ].
	self arguments with: right arguments do: [ :l :r | l type = r type ifFalse: [ ^ false ] ].
	^ true
]

{ #category : #adding }
SWMethodInfo >> addLocalVariable: aVariableInfo [
	self stack push: aVariableInfo afterIndex: self numTemps.
	self numTemps: self numTemps + 1.
	aVariableInfo stackPos: self numTemps.
]

{ #category : #accessing }
SWMethodInfo >> allTemps [
	^ self stack copyFrom: 1 to: self numTemps
]

{ #category : #accessing }
SWMethodInfo >> arguments [
	^ self stack copyFrom: 1 to: self method numArgs
]

{ #category : #accessing }
SWMethodInfo >> classInfo [

	^ classInfo ifNil: [
		classInfo := (self pool add: self) classInfo.
	]
]

{ #category : #accessing }
SWMethodInfo >> classInfo: anObject [

	classInfo := anObject
]

{ #category : #api }
SWMethodInfo >> decode [
	oldPC ifNotNil: [ ^ self ].

	(stack at: 0)
		name: 'self';
		stackPos: 0.
	self method class = CompiledMethod ifFalse: [ self error: 'something go wrong.' ].
	self method temporaryVariables doWithIndex: [ :var :idx |
		(stack at: idx)
			name: var name;
			stackPos: idx
	].
	self classInfo ifNil: [ self error: 'something wrong.' ].

	super decode.

]

{ #category : #'as yet unclassified' }
SWMethodInfo >> decodeAllOf: aNeedle [
	self decode.
	self messages do: [ :mi |
		(aNeedle value: mi) ifTrue: [ mi decodeAllOf: aNeedle ]
	]
]

{ #category : #testing }
SWMethodInfo >> hasExplicitReturn [
	^ self  return stackPos ~= -1
]

{ #category : #testing }
SWMethodInfo >> isReceiverMethod [
	^ self receiverClass = self method methodClass
]

{ #category : #accessing }
SWMethodInfo >> locals [
	^ self stack copyFrom: self method numArgs + 1 to: self numTemps
]

{ #category : #accessing }
SWMethodInfo >> mangledName [
	^ mangledName ifNil: [ mangledName := String streamContents: [ :s ||owner|
		owner := (method class = ByteString ifTrue: [ self return type ] ifFalse: [ self method methodClass ]).
		owner class = Metaclass ifTrue: [ 
			s << owner soleInstance name; << 'C'
		] ifFalse: [
			s << owner name; << '_'
		].
"
		(self const ifTrue: ['C'] ifFalse: ['_']).
"
		s
			<< (self class safeSelectorNameOf: (method class = ByteString ifTrue: [ method ] ifFalse: [ method selector ]));
			<< (self arguments collect: [ :v |
				v mangledTypeName
			])
	] ]
]

{ #category : #accessing }
SWMethodInfo >> mangledName: anObject [

	mangledName := anObject
]

{ #category : #accessing }
SWMethodInfo >> messages [

	^ messages ifNil: [ messages := OrderedDictionary new ]
]

{ #category : #accessing }
SWMethodInfo >> messages: anObject [

	messages := anObject
]

{ #category : #accessing }
SWMethodInfo >> method [
	^ method class = ByteSymbol ifTrue: [
		method := (self class search: method in: self receiverClass) ifNil: [ self error ]
	] ifFalse: [ method ]

]

{ #category : #accessing }
SWMethodInfo >> name [

	^ self method selector asString
]

{ #category : #accessing }
SWMethodInfo >> numTemps [

	^ numTemps ifNil: [ numTemps := self method numTemps ]
]

{ #category : #accessing }
SWMethodInfo >> numTemps: anObject [

	numTemps := anObject
]

{ #category : #accessing }
SWMethodInfo >> pool [

	^ pool ifNil: [ pool := self class newDefaultPool ]
]

{ #category : #accessing }
SWMethodInfo >> pool: anObject [

	pool := anObject
]

{ #category : #api }
SWMethodInfo >> ready [
	^ self subclassResponsibility 
]

{ #category : #NOCompletion }
SWMethodInfo >> receiverClass [
	^ (self stack at: 0) type
]

{ #category : #accessing }
SWMethodInfo >> return [

	^ return ifNil: [
		return := SWVariableInfo new
	]
]

{ #category : #accessing }
SWMethodInfo >> return: anObject [

	return := anObject
]

{ #category : #comparing }
SWMethodInfo >> sourceHash [
	^ SHA256 hashStream: (
		(ReadWriteStream with: '')
			<< self mangledName;
			cr;
			<< self method sourceCode;
			reset;
			yourself
	)

]

{ #category : #accessing }
SWMethodInfo >> stack [

	^ stack ifNil: [ stack := SWStack new ]
]

{ #category : #accessing }
SWMethodInfo >> stack: anObject [

	stack := anObject
]

{ #category : #accessing }
SWMethodInfo >> types: anObject [

	anObject doWithIndex: [ :type :idx |
		type class = SWVariableInfo ifTrue: [
			(self stack at: idx - 1) << type
		] ifFalse: [
			(self stack at: idx - 1)
				type: type
		]
	]
]

{ #category : #accessing }
SWMethodInfo >> variableInfoOf: aName [
	^ self stack detect: [ :vi |
		vi name = aName
	] ifNone: [
		self classInfo variableInfoOf: aName
	]
]
