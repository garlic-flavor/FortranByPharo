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
		'return'
	],
	#category : #'SWFortranByPharo-Analyzer-Analyzer'
}

{ #category : #accessing }
SWCompiledCode >> argNames [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWCompiledCode >> arguments [
	^ self slot copyFrom: self numHiddenArgs + 1 to: self numHiddenArgs + self numArgs
]

{ #category : #accessing }
SWCompiledCode >> atOffset: anOffset [
	^ self slot at: anOffset + self numHiddenArgs + 1
]

{ #category : #accessing }
SWCompiledCode >> code [
	^ self payload
]

{ #category : #copying }
SWCompiledCode >> copySlotForFullClosure: numCopied [
	^ (SWSlot new: numCopied + self numHiddenArgs)
		addLast: self hiddenArgs;
		addLast: (self copyTop: numCopied);
		yourself

]

{ #category : #copying }
SWCompiledCode >> copyTop: num [
	^ self slot copyFrom: self slot size - num + 1 to: self slot size.
]

{ #category : #accessing }
SWCompiledCode >> declaringNames [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWCompiledCode >> declarings [
	^ self slot copyFrom: self numHiddenArgs + self numArgs + 1 to: self numHiddenArgs + self numTemps
]

{ #category : #'as yet unclassified' }
SWCompiledCode >> dup [
	^ self push: self top
]

{ #category : #enumerating }
SWCompiledCode >> getVariableNameOf: aName ifFound: aFoundBlock ifNone: aNoneBlock [
	^ self slot detect: [ :each | each name = aName ] ifFound: aFoundBlock ifNone: aNoneBlock
]

{ #category : #accessing }
SWCompiledCode >> hiddenArgs [
	^ self slot copyFrom: 1 to: self numHiddenArgs
]

{ #category : #tests }
SWCompiledCode >> isDecodable [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWCompiledCode >> locals [
	^ self slot copyFrom: self numHiddenArgs + 1  to: self numHiddenArgs + self numLocals
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
SWCompiledCode >> numHiddenArgs [
	^ self subclassResponsibility
]

{ #category : #accessing }
SWCompiledCode >> numLocals [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWCompiledCode >> numTemps [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWCompiledCode >> operands: operands [
	"The first element of operands is a type of receiver."

	operands doWithIndex: [ :each :idx |
		(self slot at: idx) << each
	].
	self receiver priority: SWType receiverTypePriority 
]

{ #category : #accessing }
SWCompiledCode >> payload [

	^ payload
]

{ #category : #accessing }
SWCompiledCode >> payload: anObject [

	payload := anObject
]

{ #category : #removing }
SWCompiledCode >> pop [
	^ self slot pop
]

{ #category : #printing }
SWCompiledCode >> printOn: aStream [
	^ self putOn: aStream
]

{ #category : #adding }
SWCompiledCode >> push: anObject [
	^ self slot push: anObject
]

{ #category : #streaming }
SWCompiledCode >> putOn: aStream [
	aStream << self selector
]

{ #category : #accessing }
SWCompiledCode >> receiver [
	^ self slot receiver
]

{ #category : #accessing }
SWCompiledCode >> receiverClass [
	^ self slot receiver value
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
SWCompiledCode >> slot [

	^ slot ifNil: [
		slot := SWSlot new.
		slot allocate: self numLocals + 1.
		slot first name: 'self'.
		self tempNames doWithIndex: [ :each :idx |
			(slot at: idx + 1) name: each
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

{ #category : #accessing }
SWCompiledCode >> top [
	^ self slot last
]
