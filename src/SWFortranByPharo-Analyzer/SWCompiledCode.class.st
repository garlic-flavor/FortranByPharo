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
	self error

]

{ #category : #'instance creation' }
SWCompiledCode class >> new: aMethod with: anArrayOfVariableTypeInfoOrTypes [
	^ (self new: aMethod)
		types: anArrayOfVariableTypeInfoOrTypes;
		yourself

]

{ #category : #'as yet unclassified' }
SWCompiledCode class >> senderTranspilerClass [
	^ SWSender
]

{ #category : #accessing }
SWCompiledCode >> arguments [
	^ self stack copyFrom: 1 to: self method numArgs
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
			stackPos: idx + aFullClosure numArgs
	].
	method := aFullClosure compiledBlock


]

{ #category : #accessing }
SWCompiledCode >> cblock: aCompiledBlock [
	
	aCompiledBlock argumentNames doWithIndex: [ :name :idx |
		(self stack at: idx)
			name: name;
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
SWCompiledCode >> method: aCompiledMethod [
	aCompiledMethod temporaryVariables doWithIndex: [ :var :idx |
		(self stack at: idx)
			name: var name;
			stackPos: idx
	].
	^ super method: aCompiledMethod
]

{ #category : #accessing }
SWCompiledCode >> methodClass [
	^ method class = CompiledMethod ifTrue: [ method methodClass ] ifFalse: [ nil ]
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
	^ return ifNil: [ return := SWVariableTypeInfo new ]
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

	^ #closure
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
