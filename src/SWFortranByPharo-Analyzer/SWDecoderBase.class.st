"
SWCompiledCodeInfo has informations about Pharo's method to transpile.


"
Class {
	#name : #SWDecoderBase,
	#superclass : #SymbolicBytecodeBuilder,
	#instVars : [
		'stack',
		'return',
		'classInfo',
		'senders',
		'logger'
	],
	#category : #'SWFortranByPharo-Analyzer-Analyzer'
}

{ #category : #accessing }
SWDecoderBase class >> classTranspilerClass [

	^ SWClass
]

{ #category : #'instance creation' }
SWDecoderBase class >> new: aMethod [
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
	self error

]

{ #category : #'instance creation' }
SWDecoderBase class >> new: aMethod with: anArrayOfVariableTypeInfoOrTypes [
	^ (self new: aMethod)
		types: anArrayOfVariableTypeInfoOrTypes;
		yourself

]

{ #category : #'as yet unclassified' }
SWDecoderBase class >> senderTranspilerClass [
	^ SWSender
]

{ #category : #adding }
SWDecoderBase >> addLocalNames: aNode [

]

{ #category : #accessing }
SWDecoderBase >> arguments [
	^ self stack copyFrom: 1 to: self numArgs
]

{ #category : #accessing }
SWDecoderBase >> block: aFullClosure [
self halt.
	aFullClosure argumentNames doWithIndex: [ :name :idx |
		(self stack at: idx) name: name
	].
	aFullClosure tempNames doWithIndex: [ :name :idx |
		(self stack at: idx + aFullClosure numArgs) name: name
	].
	method := aFullClosure compiledBlock


]

{ #category : #accessing }
SWDecoderBase >> cblock: aCompiledBlock [
	
	aCompiledBlock argumentNames doWithIndex: [ :name :idx |
		(self stack at: idx) name: name
	].

	aCompiledBlock sourceNode temporaryNames doWithIndex: [ :name :idx |
		(self stack at: aCompiledBlock numArgs + idx) name: name
	].
	method := aCompiledBlock

]

{ #category : #accessing }
SWDecoderBase >> classInfo [
	"This is a SWClass"
	^ classInfo
]

{ #category : #accessing }
SWDecoderBase >> classInfo: anObject [

	classInfo := anObject
]

{ #category : #api }
SWDecoderBase >> decode [
	self isDecoded ifTrue: [ ^self ].
	self logger log: 'decoding start' withStack: self stack.
	super decode.

]

{ #category : #accessing }
SWDecoderBase >> getVariableInfoOf: aName [
	"This searches a SWVariableTypeInfo by its name."
	^ self stack detect: [ :vi |
		vi name = aName
	] ifNone: [
		self classInfo getVariableInfoOf: aName
	]
]

{ #category : #accessing }
SWDecoderBase >> getVariableInfoOf: aName ifPresent: aPresentBlock [
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

{ #category : #testing }
SWDecoderBase >> isDecoded [
	^ oldPC isNotNil
]

{ #category : #accessing }
SWDecoderBase >> locals [
	"This returns local variables excluding its arguments."
	^ self stack copyFrom: self numArgs + 1 to: self numTemps

]

{ #category : #accessing }
SWDecoderBase >> logger [

	^ logger ifNil: [ logger := SWLogger new ]
]

{ #category : #accessing }
SWDecoderBase >> logger: anObject [

	logger := anObject
]

{ #category : #modifying }
SWDecoderBase >> markAsDecoded [
	oldPC := 9999
]

{ #category : #accessing }
SWDecoderBase >> method: aCompiledMethod [
	aCompiledMethod temporaryVariables doWithIndex: [ :var :idx |
		(self stack at: idx) name: var name
	].
	(aCompiledMethod temporaryVariables size + 1) to: aCompiledMethod numTemps do: [ :idx |
		self stack at: idx
	].

	^ super method: aCompiledMethod
]

{ #category : #accessing }
SWDecoderBase >> methodClass [
	^ method class = CompiledMethod ifTrue: [ method methodClass ] ifFalse: [ nil ]
]

{ #category : #accessing }
SWDecoderBase >> numArgs [

	^ self method numArgs
]

{ #category : #accessing }
SWDecoderBase >> numTemps [
	self method class = CompiledMethod ifTrue: [
		^ self method tempNames size
	].
	self method class = CompiledBlock ifTrue: [
		^ self method numTemps
	].
	self error.
]

{ #category : #printing }
SWDecoderBase >> printOn: aStream [
	self putOn: aStream
]

{ #category : #streaming }
SWDecoderBase >> putOn: aStream [
	aStream << self selector
]

{ #category : #accessing }
SWDecoderBase >> receiverClass [
	^ (self stack at: 0) value
]

{ #category : #accessing }
SWDecoderBase >> return [
	"The return type of this method."
	^ return ifNil: [ return := SWVariableTypeInfo new ]
]

{ #category : #accessing }
SWDecoderBase >> return: anObject [

	return := anObject
]

{ #category : #accessing }
SWDecoderBase >> selector [
	method class = CompiledMethod ifTrue: [
		^ method selector
	].

	^ #closure
]

{ #category : #accessing }
SWDecoderBase >> senders [

	^ senders ifNil: [ senders := OrderedDictionary new ]
]

{ #category : #accessing }
SWDecoderBase >> senders: anObject [

	senders := anObject
]

{ #category : #accessing }
SWDecoderBase >> stack [
	"The stack at 0 corresponds to a receiver."
	^ stack ifNil: [
		stack := SWStackOld new.
		(stack at: 0)
			name: 'self';
			priority: SWType receiverTypePriority.
		stack
	]
]

{ #category : #accessing }
SWDecoderBase >> stack: anObject [

	stack := anObject
]

{ #category : #accessing }
SWDecoderBase >> types: anArray [
	"anArray is 'operands'. So, the first element of anArray is a type of receiver."
	anArray doWithIndex: [ :type :idx |
		(self stack at: idx - 1) << type
	]
]
