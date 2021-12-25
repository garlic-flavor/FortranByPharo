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

{ #category : #accessing }
SWCompiledCodeInfo class >> classTranspilerClass [
	^ SWClass
]

{ #category : #'as yet unclassified' }
SWCompiledCodeInfo class >> mangleClass [
	^ SWMangle
]

{ #category : #'instance creation' }
SWCompiledCodeInfo class >> new: aMethod with: anArrayOfVariableTypeInfoOrTypes [
	^ self new
		method: aMethod;
		types: anArrayOfVariableTypeInfoOrTypes;
		yourself

]

{ #category : #'instance creation' }
SWCompiledCodeInfo class >> newDefaultPool [
	^ SWPool new
		transpilerClass: self;
		classTranspilerClass: self classTranspilerClass;
		yourself
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

	^ classInfo
]

{ #category : #accessing }
SWCompiledCodeInfo >> classInfo: anObject [

	classInfo := anObject
]

{ #category : #api }
SWCompiledCodeInfo >> decode [
	oldPC ifNotNil: [ ^ self ].

	(self stack at: 0)
		name: 'self';
		stackPos: 0.

	self method class = CompiledMethod ifTrue: [
		self method temporaryVariables doWithIndex: [ :var :idx |
			(self stack at: idx)
				name: var name;
				stackPos: idx
		].
		self method argumentNames doWithIndex: [ :var :idx |
			(self stack at: idx)
				priority: SWType argumentTypePriority
		]
	].
	self method class = FullBlockClosure ifTrue: [
		self method argumentNames doWithIndex: [ :name :idx |
			(self stack at: idx)
				name: name;
				stackPos: idx
		].
		self method tempNames doWithIndex: [ :name :idx |
			(self stack at: idx)
				name: name;
				stackPos: idx + self method numArgs
		].
		self method: self method compiledBlock
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
SWCompiledCodeInfo >> isToTranspile [
	^ self classInfo isNil or: [ self classInfo isToTranspile ]
]

{ #category : #accessing }
SWCompiledCodeInfo >> locals [
	^ self stack copyFrom: self method numArgs + 1 to: self numTemps
]

{ #category : #accessing }
SWCompiledCodeInfo >> mangledName [
	^ mangledName ifNil: [
		mangledName := self class mangleClass methodNameOf: self method with: self arguments
	]
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
	^ method
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

{ #category : #copying }
SWCompiledCodeInfo >> postCopy [
	super postCopy.
	self stack: self stack copy
]

{ #category : #NOCompletion }
SWCompiledCodeInfo >> receiverClass [
	^ (self stack at: 0) value
]

{ #category : #accessing }
SWCompiledCodeInfo >> return [

	^ return ifNil: [
		return := SWVariableTypeInfo new
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
		(self stack at: idx - 1) << type
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
