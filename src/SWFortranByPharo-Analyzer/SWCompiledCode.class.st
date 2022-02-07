"
SWCompiledCodeInfo has informations about Pharo's method to transpile.


"
Class {
	#name : #SWCompiledCode,
	#superclass : #SymbolicBytecodeBuilder,
	#instVars : [
		'stack',
		'return',
		'classInfo',
		'numTemps',
		'senders'
	],
	#category : #'SWFortranByPharo-Analyzer-Analyzer'
}

{ #category : #accessing }
SWCompiledCode class >> classTranspilerClass [

	^ SWClass
]

{ #category : #'instance creation' }
SWCompiledCode class >> new: aMethod [
	aMethod isBlock ifTrue: [
		^ self new
			block: aMethod;
			yourself
	].
	aMethod class = CompiledBlock ifTrue: [
		^ self new
			cblock: aMethod;
			yourself
	].
	aMethod class = CompiledMethod ifTrue: [
		^ self new
			method: aMethod;
			yourself
	].
	aMethod class = ByteSymbol ifTrue: [
		self error; flag: #toRemove.
		^ self new
			selector: aMethod;
			yourself
	].
	self error

]

{ #category : #'instance creation' }
SWCompiledCode class >> new: aMethod with: anArrayOfVariableTypeInfoOrTypes [
	^ (self new: aMethod)
		types: anArrayOfVariableTypeInfoOrTypes;
		yourself

]

{ #category : #'instance creation' }
SWCompiledCode class >> newDefaultPool [
	self error; flag: #toRemove.
	^ self poolClass new
		transpilerClass: self;
		yourself
]

{ #category : #'instance creation' }
SWCompiledCode class >> newFrom: anOriginal [
	self error; flag: #toRemove.
	^ self new
		copyFrom: anOriginal;
		yourself
]

{ #category : #'as yet unclassified' }
SWCompiledCode class >> senderTranspilerClass [
	^ SWSender
]

{ #category : #adding }
SWCompiledCode >> addLocalVariable: aVariableInfo [
	self error; flag: #toRemove.
	self stack push: aVariableInfo afterIndex: self numTemps.
	self numTemps: self numTemps + 1.
	aVariableInfo stackPos: self numTemps.
]

{ #category : #accessing }
SWCompiledCode >> allTemps [
	self error; flag: #toRemove.
	^ self stack copyFrom: 1 to: self method numTemps
]

{ #category : #accessing }
SWCompiledCode >> arguments [
	^ self stack copyFrom: 1 to: self method numArgs
]

{ #category : #converting }
SWCompiledCode >> asCallee [
	"This will be called to preserve #message member variable."
	self error; flag: #toRewrite.
	^ self copy
]

{ #category : #accessing }
SWCompiledCode >> block: aFullClosure [

	aFullClosure argumentNames doWithIndex: [ :name :idx |
		(self stack at: idx)
			name: name;
			stackPos: idx
	].
	aFullClosure tempNames doWithIndex: [ :name :idx |
		(self stack at: idx + aFullClosure numArgs)
			name: name;
			owner: self;
			pc: 0;
			stackPos: idx + aFullClosure numArgs
	].
	method := aFullClosure compiledBlock


]

{ #category : #accessing }
SWCompiledCode >> cblock: aCompiledBlock [
	
	aCompiledBlock argumentNames doWithIndex: [ :name :idx |
		(self stack at: idx)
			name: name;
			owner: self;
			pc: 0;
			stackPos: idx
	].
	method := aCompiledBlock

]

{ #category : #accessing }
SWCompiledCode >> classInfo [
	"This is a SWClass"
	^ classInfo
]

{ #category : #accessing }
SWCompiledCode >> classInfo: anObject [

	classInfo := anObject
]

{ #category : #copying }
SWCompiledCode >> copyFrom: right [
	self error; flag: #toRewrite.
	method := right method.
	stack := right stack.
	right isDecoded ifTrue: [ self markAsDecoded ]
]

{ #category : #api }
SWCompiledCode >> decode [
	self isDecoded ifTrue: [ ^self ].
	super decode.

]

{ #category : #accessing }
SWCompiledCode >> getVariableInfoOf: aName [
	"This searches a SWVariableTypeInfo by its name."
	^ self stack detect: [ :vi |
		vi name = aName
	] ifNone: [
		self classInfo getVariableInfoOf: aName
	]
]

{ #category : #accessing }
SWCompiledCode >> getVariableInfoOf: aName ifPresent: aPresentBlock [
	"This searches a SWVariableTypeInfo by its name."
	^ self stack detect: [ :vi |
		vi name = aName
	] ifFound: [ :vi |
		aPresentBlock cull: vi
	] ifNone: [
		self classInfo ifNotNil: [ self classInfo getVariableInfoOf: aName ifPresent: aPresentBlock ].
		nil
	]
]

{ #category : #comparing }
SWCompiledCode >> hash [
	"The hash depends on this method and its operands."
	|args buf|
	self error; flag: #toRemove.
	args := self operands.
	buf := OrderedCollection new: args size + 1.
	buf add: self method hash.
	buf addAll: (args collect: [ :one |
		one type hash
	]).
	^ buf hash
]

{ #category : #testing }
SWCompiledCode >> isDecoded [
	^ oldPC isNotNil
]

{ #category : #accessing }
SWCompiledCode >> locals [
	"This returns local variables excluding its arguments."
	^ self stack copyFrom: self method numArgs + 1 to: self method numTemps
]

{ #category : #modifying }
SWCompiledCode >> markAsDecoded [
	oldPC := 9999
]

{ #category : #accessing }
SWCompiledCode >> messages [
	self error; flag: #toRemove.
	"messages is used to 2 deferent purpose.
	The one is to store transpilers to transpile the contents of the method.
	Another is to store transpilers to transpile its arguments when transpiling it as a callee.
	In latter case, messages correspond to these of outer transpiler."
"
	^ messages ifNil: [ messages := OrderedDictionary new ]
"
]

{ #category : #accessing }
SWCompiledCode >> messages: anObject [
	self error; flag: #toRemove.
"
	messages := anObject
"
]

{ #category : #accessing }
SWCompiledCode >> method: aCompiledMethod [
	aCompiledMethod temporaryVariables doWithIndex: [ :var :idx |
		(self stack at: idx)
			name: var name;
			owner: self;
			pc: 0;
			stackPos: idx
	].
	aCompiledMethod argumentNames doWithIndex: [ :var :idx |
		(self stack at: idx)
			owner: self;
			pc: 0
	].

	^ super method: aCompiledMethod
]

{ #category : #accessing }
SWCompiledCode >> methodClass [
	^ method class = CompiledMethod ifTrue: [ method methodClass ] ifFalse: [ nil ]
]

{ #category : #accessing }
SWCompiledCode >> name [
	self error; flag: #toRemove.
	^ self method selector asString
]

{ #category : #accessing }
SWCompiledCode >> numTemps [
	self error; flag: #toRemove.

	^ numTemps ifNil: [ numTemps := self method numTemps ]
]

{ #category : #accessing }
SWCompiledCode >> numTemps: anObject [
	self error; flag: #toRemove.
	numTemps := anObject
]

{ #category : #accessing }
SWCompiledCode >> operands [
	"The operands consist of its receiver and its arguments."
	method class = CompiledMethod ifTrue: [
		^ self stack copyFrom: 0 to: self method numArgs
	].
	method class = ByteSymbol ifTrue: [
		self error; flag: #toRemove.
		^ #()
	].
	self error
]

{ #category : #printing }
SWCompiledCode >> printOn: aStream [
	self putOn: aStream
]

{ #category : #streaming }
SWCompiledCode >> putOn: aStream [
	aStream << self selector
]

{ #category : #accessing }
SWCompiledCode >> receiverClass [
	^ (self stack at: 0) value
]

{ #category : #accessing }
SWCompiledCode >> return [
	"The return type of this method."
	^ return ifNil: [
		return := (SWVariableTypeInfo new)
			owner: self;
			pc: 0;
			yourself
	]
]

{ #category : #accessing }
SWCompiledCode >> return: anObject [

	return := anObject
]

{ #category : #accessing }
SWCompiledCode >> selector [
	method class = CompiledMethod ifTrue: [
		^ method selector
	].

	method class = ByteSymbol ifTrue: [
		self error; flag: #toRemove.
		^ method
	].

	^ #closure
]

{ #category : #accessing }
SWCompiledCode >> selector: aSelector [
	self error; flag: #toRemove.
	method := aSelector.
	self markAsDecoded
]

{ #category : #accessing }
SWCompiledCode >> senders [

	^ senders ifNil: [ senders := OrderedDictionary new ]
]

{ #category : #accessing }
SWCompiledCode >> senders: anObject [

	senders := anObject
]

{ #category : #accessing }
SWCompiledCode >> specifyReturnTypeAs: aType [

	self return
		<< aType;
		priority: SWType userSpecifyingPriority
]

{ #category : #accessing }
SWCompiledCode >> stack [
	"The stack at 0 corresponds to a receiver."
	^ stack ifNil: [
		stack := SWStack new.
		(stack at: 0)
			name: 'self';
			priority: SWType receiverTypePriority;
			stackPos: 0.
		stack
	]
]

{ #category : #accessing }
SWCompiledCode >> stack: anObject [

	stack := anObject
]

{ #category : #accessing }
SWCompiledCode >> types: anArray [
	"anArray is 'operands'. So, the first element of anArray is a type of receiver."
	anArray doWithIndex: [ :type :idx |
		(self stack at: idx - 1) << type
	]
]