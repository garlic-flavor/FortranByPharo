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
SWCompiledCodeInfo class >> new: aMethod [
	^ self new: aMethod with: #()
]

{ #category : #'instance creation' }
SWCompiledCodeInfo class >> new: aMethod with: anArrayOfVariableTypeInfoOrTypes [
	^ (aMethod isBlock ifTrue: [
		self new
			block: aMethod;
			yourself
	] ifFalse: [
		self new
			method: aMethod;
			yourself
	])
		types: anArrayOfVariableTypeInfoOrTypes;
		yourself.		

]

{ #category : #'instance creation' }
SWCompiledCodeInfo class >> newDefaultPool [
	^ SWPool new
		transpilerClass: self;
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
SWCompiledCodeInfo >> block: aBlock [
	aBlock argumentNames doWithIndex: [ :name :idx |
		(self stack at: idx)
			name: name;
			stackPos: idx
	].
	aBlock tempNames doWithIndex: [ :name :idx |
		(self stack at: idx)
			name: name;
			owner: self;
			pc: 0;
			stackPos: idx + aBlock numArgs
	].
	super method: aBlock compiledBlock


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
	self isDecoded ifTrue: [ ^self ].
	super decode.

]

{ #category : #testing }
SWCompiledCodeInfo >> isDecoded [
	^ oldPC isNotNil
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

{ #category : #'as yet unclassified' }
SWCompiledCodeInfo >> markAsDecoded [
	oldPC := 9999
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
SWCompiledCodeInfo >> method: aMethod [
	aMethod temporaryVariables doWithIndex: [ :var :idx |
		(self stack at: idx)
			name: var name;
			owner: self;
			pc: 0;
			stackPos: idx
	].
	aMethod argumentNames doWithIndex: [ :var :idx |
		(self stack at: idx)
			owner: self;
			pc: 0;
			priority: SWType argumentTypePriority
	].

	^ super method: aMethod
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

{ #category : #printing }
SWCompiledCodeInfo >> printOn: aStream [
	self putOn: aStream
]

{ #category : #printing }
SWCompiledCodeInfo >> putOn: aStream [
	aStream << (method class = CompiledMethod ifTrue: [ method name ] ifFalse: [ 'block' ])
]

{ #category : #NOCompletion }
SWCompiledCodeInfo >> receiverClass [
	^ (self stack at: 0) value
]

{ #category : #accessing }
SWCompiledCodeInfo >> return [

	^ return ifNil: [
		return := (SWVariableTypeInfo new)
			owner: self;
			pc: 0;
			yourself
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

	^ stack ifNil: [
		stack := SWStack new.
		(stack at: 0)
			name: 'self';
			stackPos: 0.
		stack
	]
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
