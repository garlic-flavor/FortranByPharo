"
SWCalleeInfo contains informations of callee to call.
#method member variable may contains FullClosure, CompiledMethod, CompiledBlock or ByteString as its selector name.
"
Class {
	#name : #SWCalleeInfo,
	#superclass : #SymbolicBytecodeBuilder,
	#instVars : [
		'stack'
	],
	#category : #'SWFortranByPharo-Analyzer-Analyzer'
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
	"This will be called to preserve #message member variable."
	^ self copy
]

{ #category : #accessing }
SWCalleeInfo >> block: aFullClosure [

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
SWCalleeInfo >> cblock: aCompiledBlock [
	
	aCompiledBlock argumentNames doWithIndex: [ :name :idx |
		(self stack at: idx)
			name: name;
			owner: self;
			pc: 0;
			stackPos: idx
	].
	method := aCompiledBlock

]

{ #category : #copying }
SWCalleeInfo >> copyFrom: right [

	method := right method.
	stack := right stack.
	right isDecoded ifTrue: [ self markAsDecoded ]
]

{ #category : #comparing }
SWCalleeInfo >> hash [
	"The hash depends on this method and its operands."
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
SWCalleeInfo >> method: aCompiledMethod [
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
SWCalleeInfo >> methodClass [
	^ method class = CompiledMethod ifTrue: [ method methodClass ] ifFalse: [ nil ]
]

{ #category : #accessing }
SWCalleeInfo >> operands [
	"The operands consist of its receiver and its arguments."
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

{ #category : #streaming }
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
SWCalleeInfo >> stack: anObject [

	stack := anObject
]

{ #category : #accessing }
SWCalleeInfo >> types: anArray [
	"anArray is 'operands'. So, the first element of anArray is a type of receiver."
	anArray doWithIndex: [ :type :idx |
		(self stack at: idx - 1) << type
	]
]
