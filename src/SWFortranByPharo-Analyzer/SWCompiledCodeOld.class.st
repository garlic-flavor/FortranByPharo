"
SWCompiledCode wraps CompiledMethod, CompiledBlock and PseudoBlock.

- 1 <= numHiddenArgs.
- numArgs <= numTemps <= numLocals.
- declaringNames size = numTemps - numArgs.
"
Class {
	#name : #SWCompiledCodeOld,
	#superclass : #Object,
	#instVars : [
		'payload',
		'slot',
		'receiver',
		'return',
		'senders'
	],
	#category : #'SWFortranByPharo-Analyzer-Olds'
}

{ #category : #'instance creation' }
SWCompiledCodeOld class >> new: code receiver: receiver with: args [
	^ self new
		payload: code;
		receiver: receiver;
		arguments: args;
		yourself
]

{ #category : #accessing }
SWCompiledCodeOld >> argNames [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWCompiledCodeOld >> arguments [
	^ self slot copyFrom: 1 to: self numArgs
]

{ #category : #accessing }
SWCompiledCodeOld >> arguments: arguments [

	arguments doWithIndex: [ :each :idx |
		(self slot at: idx) << each
	]

]

{ #category : #accessing }
SWCompiledCodeOld >> declaringNames [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWCompiledCodeOld >> declarings [
	^ self slot copyFrom: self numArgs + 1 to: self numTemps
]

{ #category : #enumerating }
SWCompiledCodeOld >> getVariableNameOf: aName ifFound: aFoundBlock ifNone: aNoneBlock [
	^ self slot detect: [ :each | each name = aName ] ifFound: aFoundBlock ifNone: aNoneBlock
]

{ #category : #accessing }
SWCompiledCodeOld >> initialSize [
	^ self subclassResponsibility 
]

{ #category : #tests }
SWCompiledCodeOld >> isDecodable [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWCompiledCodeOld >> methodClass [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWCompiledCodeOld >> numArgs [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWCompiledCodeOld >> numTemps [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWCompiledCodeOld >> payload [

	^ payload
]

{ #category : #accessing }
SWCompiledCodeOld >> payload: anObject [

	payload := anObject
]

{ #category : #printing }
SWCompiledCodeOld >> printOn: aStream [
	^ self putOn: aStream
]

{ #category : #streaming }
SWCompiledCodeOld >> putOn: aStream [
	aStream << self selector
]

{ #category : #accessing }
SWCompiledCodeOld >> receiver [
	^ receiver ifNil: [
		receiver := SWVariableType new
			priority: SWType receiverTypePriority;
			yourself
	]
]

{ #category : #accessing }
SWCompiledCodeOld >> receiver: anObject [

	receiver := anObject
]

{ #category : #accessing }
SWCompiledCodeOld >> receiverClass [
	^ receiver value
]

{ #category : #accessing }
SWCompiledCodeOld >> return [

	^ return ifNil: [ return := SWVariableType new ]
]

{ #category : #accessing }
SWCompiledCodeOld >> return: anObject [

	return := anObject
]

{ #category : #accessing }
SWCompiledCodeOld >> selector [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWCompiledCodeOld >> senders [

	^ senders ifNil: [ senders := OrderedDictionary new ]
]

{ #category : #accessing }
SWCompiledCodeOld >> senders: anObject [

	senders := anObject
]

{ #category : #accessing }
SWCompiledCodeOld >> slot [

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
SWCompiledCodeOld >> slot: anObject [

	slot := anObject
]

{ #category : #accessing }
SWCompiledCodeOld >> sourceNode [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWCompiledCodeOld >> tempNames [
	^ self subclassResponsibility 
]
