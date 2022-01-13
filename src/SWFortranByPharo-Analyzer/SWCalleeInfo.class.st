"
I contains informations of callee to call.
"
Class {
	#name : #SWCalleeInfo,
	#superclass : #SymbolicBytecodeBuilder,
	#instVars : [
		'stack'
	],
	#category : #'SWFortranByPharo-Analyzer-Method'
}

{ #category : #'instance creation' }
SWCalleeInfo class >> new: aMethod [
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
		^ self new
			selector: aMethod;
			yourself
	].
	self error

]

{ #category : #'instance creation' }
SWCalleeInfo class >> new: aMethod with: anArrayOfVariableTypeInfoOrTypes [
	^ (self new: aMethod)
		types: anArrayOfVariableTypeInfoOrTypes;
		yourself

]

{ #category : #'instance creation' }
SWCalleeInfo class >> newFrom: anOriginal [
	^ self new
		copyFrom: anOriginal;
		yourself
]

{ #category : #comparing }
SWCalleeInfo >> = right [
	self method = right method ifFalse: [ ^ false ].
	self operands = right operands ifFalse: [ ^ false ].
	^ true
]

{ #category : #accessing }
SWCalleeInfo >> arguments [
	^ self stack copyFrom: 1 to: self method numArgs
]

{ #category : #converting }
SWCalleeInfo >> asCallee [
	^ self copy
]

{ #category : #accessing }
SWCalleeInfo >> block: aBlock [
	aBlock argumentNames doWithIndex: [ :name :idx |
		(self stack at: idx)
			name: name;
			stackPos: idx
	].
	aBlock tempNames doWithIndex: [ :name :idx |
		(self stack at: idx + aBlock numArgs)
			name: name;
			owner: self;
			pc: 0;
			stackPos: idx + aBlock numArgs
	].
	super method: aBlock compiledBlock


]

{ #category : #accessing }
SWCalleeInfo >> cblock: aBlock [
	aBlock argumentNames doWithIndex: [ :name :idx |
		(self stack at: idx)
			name: name;
			owner: self;
			pc: 0;
			stackPos: idx
	].
	super method: aBlock

]

{ #category : #copying }
SWCalleeInfo >> copyFrom: right [

	method := right method.
	stack := right stack.
	right isDecoded ifTrue: [ self markAsDecoded ]
]

{ #category : #comparing }
SWCalleeInfo >> hash [
	|args buf|
	args := self operands.
	buf := OrderedCollection new: args size + 1.
	buf add: self method hash.
	buf addAll: (args collect: [ :one |
		one type hash
	]).
	^ buf hash
]

{ #category : #testing }
SWCalleeInfo >> isDecoded [
	^ oldPC isNotNil
]

{ #category : #modifying }
SWCalleeInfo >> markAsDecoded [
	oldPC := 9999
]

{ #category : #accessing }
SWCalleeInfo >> method: aMethod [
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
			pc: 0
	].

	^ super method: aMethod
]

{ #category : #accessing }
SWCalleeInfo >> operands [
	method class = CompiledMethod ifTrue: [
		^ self stack copyFrom: 0 to: self method numArgs
	].
	method class = ByteSymbol ifTrue: [
		^ #()
	].
	self error
]

{ #category : #printing }
SWCalleeInfo >> printOn: aStream [
	self putOn: aStream
]

{ #category : #printing }
SWCalleeInfo >> putOn: aStream [
	aStream << self selector
]

{ #category : #accessing }
SWCalleeInfo >> receiverClass [
	^ (self stack at: 0) value
]

{ #category : #accessing }
SWCalleeInfo >> selector [
	method class = CompiledMethod ifTrue: [
		^ method selector
	].

	method class = ByteSymbol ifTrue: [
		^ method
	].

	^ #closure
]

{ #category : #accessing }
SWCalleeInfo >> selector: aSelector [
	method := aSelector.
	self markAsDecoded
]

{ #category : #accessing }
SWCalleeInfo >> stack [

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
SWCalleeInfo >> stack: anObject [

	stack := anObject
]

{ #category : #accessing }
SWCalleeInfo >> targetClass [
	^ method class = CompiledMethod ifTrue: [ method methodClass ] ifFalse: [ nil ]
]

{ #category : #accessing }
SWCalleeInfo >> types: anObject [
	anObject doWithIndex: [ :type :idx |
		(self stack at: idx - 1) << type
	]
]
