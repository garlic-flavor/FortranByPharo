"
SWCompiledCode wraps CompiledMethod, CompiledBlock and PseudoBlock.
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

{ #category : #'instance creation' }
SWCompiledCode class >> new: compiledCode [
	compiledCode class = CompiledMethod ifTrue: [
		^ SWCompiledMethod new
			payload: compiledCode;
			yourself.
	]
]

{ #category : #accessing }
SWCompiledCode >> argNames [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWCompiledCode >> arguments [
	^ self slot copyFrom: 2 to: self numArgs + 1
]

{ #category : #accessing }
SWCompiledCode >> code [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWCompiledCode >> declaringNames [
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SWCompiledCode >> getVariableNameOf: aName ifFound: aFoundBlock ifNone: aNoneBlock [
	^ self slot detect: [ :each | each name = aName ] ifFound: aFoundBlock ifNone: aNoneBlock
]

{ #category : #tests }
SWCompiledCode >> isDecodable [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWCompiledCode >> locals [
	^ self slot copyFrom: 2 to: self numLocals + 1
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
	]
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
