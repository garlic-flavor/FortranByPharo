"
I have informations about Pharo's method to transpile.
I'm designed as very lazy to avoid problems like circular referencing of methods.

"
Class {
	#name : #SWCompiledCodeInfo,
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
SWCompiledCodeInfo class >> new: aMethodOrSelector with: anArrayOfVariableInfoOrTypes [
	^ self new
		method: aMethodOrSelector;
		types: anArrayOfVariableInfoOrTypes;
		yourself

]

{ #category : #'instance creation' }
SWCompiledCodeInfo class >> newDefaultPool [
	^ SWPool new
		transpilerClass: self;
		yourself
]

{ #category : #utils }
SWCompiledCodeInfo class >> safeSelectorNameOf: selector [
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
SWCompiledCodeInfo class >> search: selector in: aClass [
	^ aClass ifNil: [
		nil
	] ifNotNil: [
		aClass methodDict at: selector ifAbsent: [
			self search: selector in: aClass superclass
		]
	]
]

{ #category : #comparing }
SWCompiledCodeInfo >> = right [
	self method = right method ifFalse: [ ^ false ].
	self arguments with: right arguments do: [ :l :r | l type = r type ifFalse: [ ^ false ] ].
	^ true
]

{ #category : #adding }
SWCompiledCodeInfo >> addLocalVariable: aVariableInfo [
	self stack push: aVariableInfo afterIndex: self numTemps.
	self numTemps: self numTemps + 1.
	aVariableInfo stackPos: self numTemps.
]

{ #category : #accessing }
SWCompiledCodeInfo >> allTemps [
	^ self stack copyFrom: 1 to: self numTemps
]

{ #category : #accessing }
SWCompiledCodeInfo >> arguments [
	^ self stack copyFrom: 1 to: self method numArgs
]

{ #category : #accessing }
SWCompiledCodeInfo >> classInfo [

	^ classInfo ifNil: [
		classInfo := (self pool addMethodInfo: self) classInfo.
	]
]

{ #category : #accessing }
SWCompiledCodeInfo >> classInfo: anObject [

	classInfo := anObject
]

{ #category : #api }
SWCompiledCodeInfo >> decode [
	oldPC ifNotNil: [ ^ self ].

	(stack at: 0)
		name: 'self';
		stackPos: 0.
	(self method class inheritsFrom: CompiledCode) ifFalse: [ self error: 'something go wrong.' ].
	self classInfo ifNil: [ self error: 'something wrong.' ].
	self method class = CompiledMethod ifTrue: [
		self method temporaryVariables doWithIndex: [ :var :idx |
			(stack at: idx)
				name: var name;
				stackPos: idx
		]
	].

	super decode.

]

{ #category : #'as yet unclassified' }
SWCompiledCodeInfo >> decodeAllOf: aNeedle [
	self decode.
	self messages do: [ :mi |
		(aNeedle value: mi) ifTrue: [ mi decodeAllOf: aNeedle ]
	]
]

{ #category : #testing }
SWCompiledCodeInfo >> hasExplicitReturn [
	^ self  return stackPos ~= -1
]

{ #category : #testing }
SWCompiledCodeInfo >> isReceiverMethod [
	^ self receiverClass = self method methodClass
]

{ #category : #accessing }
SWCompiledCodeInfo >> locals [
	^ self stack copyFrom: self method numArgs + 1 to: self numTemps
]

{ #category : #accessing }
SWCompiledCodeInfo >> mangledName [
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
SWCompiledCodeInfo >> mangledName: anObject [

	mangledName := anObject
]

{ #category : #accessing }
SWCompiledCodeInfo >> messages [

	^ messages ifNil: [ messages := OrderedDictionary new ]
]

{ #category : #accessing }
SWCompiledCodeInfo >> messages: anObject [

	messages := anObject
]

{ #category : #accessing }
SWCompiledCodeInfo >> method [
	^ method class = ByteSymbol ifTrue: [
		method := (self class search: method in: self receiverClass) ifNil: [ self error ]
	] ifFalse: [ method ]

]

{ #category : #accessing }
SWCompiledCodeInfo >> name [

	^ self method selector asString
]

{ #category : #accessing }
SWCompiledCodeInfo >> numTemps [

	^ numTemps ifNil: [ numTemps := self method numTemps ]
]

{ #category : #accessing }
SWCompiledCodeInfo >> numTemps: anObject [

	numTemps := anObject
]

{ #category : #accessing }
SWCompiledCodeInfo >> pool [

	^ pool ifNil: [ pool := self class newDefaultPool ]
]

{ #category : #accessing }
SWCompiledCodeInfo >> pool: anObject [

	pool := anObject
]

{ #category : #NOCompletion }
SWCompiledCodeInfo >> receiverClass [
	^ (self stack at: 0) type
]

{ #category : #accessing }
SWCompiledCodeInfo >> return [

	^ return ifNil: [
		return := SWVariableInfo new
	]
]

{ #category : #accessing }
SWCompiledCodeInfo >> return: anObject [

	return := anObject
]

{ #category : #comparing }
SWCompiledCodeInfo >> sourceHash [
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
SWCompiledCodeInfo >> stack [

	^ stack ifNil: [ stack := SWStack new ]
]

{ #category : #accessing }
SWCompiledCodeInfo >> stack: anObject [

	stack := anObject
]

{ #category : #accessing }
SWCompiledCodeInfo >> types: anObject [

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
SWCompiledCodeInfo >> variableInfoOf: aName [
	^ self stack detect: [ :vi |
		vi name = aName
	] ifNone: [
		self classInfo variableInfoOf: aName
	]
]
