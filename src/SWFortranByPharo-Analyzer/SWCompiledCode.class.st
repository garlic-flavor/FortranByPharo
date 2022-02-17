"
SWCompiledCode wraps CompiledMethod, CompiledBlock and PseudoBlock.

- 1 <= numHiddenArgs.
- numArgs <= numTemps <= numLocals.
- declaringNames size = numTemps - numArgs.
"
Class {
	#name : #SWCompiledCode,
	#superclass : #Object,
	#instVars : [
		'payload',
		'slot',
		'receiver',
		'return',
		'senders'
	],
	#category : #'SWFortranByPharo-Analyzer-Analyzer'
}

{ #category : #'instance creation' }
SWCompiledCode class >> new: code receiver: receiver args: args [
	^ self new
		payload: code;
		receiver: receiver;
		arguments: args;
		yourself
]

{ #category : #accessing }
SWCompiledCode >> argNames [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWCompiledCode >> arguments [
	^ self slot copyFrom: 1 to: self numArgs
]

{ #category : #accessing }
SWCompiledCode >> arguments: arguments [

	arguments doWithIndex: [ :each :idx |
		(self slot at: idx) << each
	]

]

{ #category : #accessing }
SWCompiledCode >> declaringNames [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWCompiledCode >> declarings [
	^ self slot copyFrom: self numArgs + 1 to: self numTemps
]

{ #category : #enumerating }
SWCompiledCode >> getVariableNameOf: aName ifFound: aFoundBlock ifNone: aNoneBlock [
	^ self slot detect: [ :each | each name = aName ] ifFound: aFoundBlock ifNone: aNoneBlock
]

{ #category : #accessing }
SWCompiledCode >> initialSize [
	^ self subclassResponsibility 
]

{ #category : #tests }
SWCompiledCode >> isDecodable [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWCompiledCode >> methodClass [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWCompiledCode >> numArgs [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWCompiledCode >> numTemps [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWCompiledCode >> payload [

	^ payload
]

{ #category : #accessing }
SWCompiledCode >> payload: anObject [

	payload := anObject
]

{ #category : #printing }
SWCompiledCode >> printOn: aStream [
	^ self putOn: aStream
]

{ #category : #streaming }
SWCompiledCode >> putOn: aStream [
	aStream << self selector
]

{ #category : #accessing }
SWCompiledCode >> receiver [
	^ receiver ifNil: [
		receiver := SWVariableTypeInfo new
			priority: SWType receiverTypePriority;
			yourself
	]
]

{ #category : #accessing }
SWCompiledCode >> receiver: anObject [

	receiver := anObject
]

{ #category : #accessing }
SWCompiledCode >> receiverClass [
	^ receiver value
]

{ #category : #accessing }
SWCompiledCode >> return [

	^ return ifNil: [ return := SWVariableTypeInfo new ]
]

{ #category : #accessing }
SWCompiledCode >> return: anObject [

	return := anObject
]

{ #category : #accessing }
SWCompiledCode >> selector [
	^ self subclassResponsibility 
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
SWCompiledCode >> slot [

	^ slot ifNil: [
		slot := SWSlot new.
		slot allocate: self initialSize.
		self tempNames doWithIndex: [ :each :idx |
			(slot at: idx) name: each
		].
		slot
	]
]

{ #category : #accessing }
SWCompiledCode >> slot: anObject [

	slot := anObject
]

{ #category : #accessing }
SWCompiledCode >> sourceNode [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWCompiledCode >> tempNames [
	^ self subclassResponsibility 
]
