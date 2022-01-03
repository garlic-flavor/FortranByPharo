"
I contains informations of callee to call.
"
Class {
	#name : #SWCalleeInfo,
	#superclass : #SymbolicBytecodeBuilder,
	#instVars : [
		'mangledName',
		'stack',
		'sourceHash'
	],
	#category : #'SWFortranByPharo-Client-Analyzer'
}

{ #category : #constants }
SWCalleeInfo class >> mangleClass [
	^ SWMangle
]

{ #category : #'instance creation' }
SWCalleeInfo class >> new: aMethod [
	^ self new: aMethod with: #()
]

{ #category : #'instance creation' }
SWCalleeInfo class >> new: aMethod with: anArrayOfVariableTypeInfoOrTypes [
	aMethod isBlock ifTrue: [
		^ self new
			block: aMethod;
			types: anArrayOfVariableTypeInfoOrTypes;
			yourself
	].
	aMethod class = CompiledBlock ifTrue: [
		^ self new
			cblock: aMethod;
			types: anArrayOfVariableTypeInfoOrTypes;
			yourself
	].
	aMethod class = CompiledMethod ifTrue: [
		^ self new
			method: aMethod;
			types: anArrayOfVariableTypeInfoOrTypes;
			yourself
	].
	self error

]

{ #category : #'instance creation' }
SWCalleeInfo class >> newFrom: anOriginal [
	^ self new
		method: anOriginal method;
		stack: anOriginal stack;
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

{ #category : #'as yet unclassified' }
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

{ #category : #accessing }
SWCalleeInfo >> mangledName [
	^ mangledName ifNil: [
		mangledName := self class mangleClass methodNameOf: self method with: self arguments
	]
]

{ #category : #accessing }
SWCalleeInfo >> mangledName: anObject [

	mangledName := anObject
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
	^ self stack copyFrom: 0 to: self method numArgs
]

{ #category : #copying }
SWCalleeInfo >> postCopy [
	super postCopy.
	self stack: self stack copy
]

{ #category : #printing }
SWCalleeInfo >> printOn: aStream [
	self putOn: aStream
]

{ #category : #printing }
SWCalleeInfo >> putOn: aStream [
	aStream << (method class = CompiledMethod ifTrue: [ method name ] ifFalse: [ 'block' ])
]

{ #category : #NOCompletion }
SWCalleeInfo >> receiverClass [
	^ (self stack at: 0) value
]

{ #category : #comparing }
SWCalleeInfo >> sourceHash [
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
SWCalleeInfo >> types: anObject [
	anObject doWithIndex: [ :type :idx |
		(self stack at: idx - 1) << type
	]
]
