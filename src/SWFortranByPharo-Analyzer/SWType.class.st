"
I am in a SWValue.
I can be used to declare the type of a variable.

```
	SWType declare: #nameOfVariable as: Integer.
```

"
Class {
	#name : #SWType,
	#superclass : #Object,
	#instVars : [
		'payload',
		'priority'
	],
	#category : #'SWFortranByPharo-Analyzer-Type'
}

{ #category : #'private - utilities' }
SWType class >> calcPriorityOf: aClass [
	aClass ifNil: [ ^ self defaultPriority ].
	aClass = UndefinedObject ifTrue: [ ^ self defaultPriority ].
	^ self exactTypePriority 
]

{ #category : #api }
SWType class >> declare: aName as: aType [

]

{ #category : #constants }
SWType class >> defaultPriority [
	^ 0
]

{ #category : #constants }
SWType class >> exactTypePriority [
	^ 90
]

{ #category : #'private - utilities' }
SWType class >> nameOfPriority: aPriority [
	^ ((SWType class methodDict values select: [ :m |
		m protocol = #constants
	] thenCollect: [ :m |
		(m valueWithReceiver: self arguments: #()) -> m
	]) sort: [ :a :b | b key < a key ]) detect: [ :m | m key <= aPriority ] ifFound: [ :m |
		m value selector copyUpToSubstring: 'Priority'
	] ifNone: [
		#unknown
	]

	
]

{ #category : #'instance creation' }
SWType class >> new: aClass [
	^ self new
		<< aClass;
		yourself
]

{ #category : #'instance creation' }
SWType class >> new: aClass with: aPriority [
	^ self new
		<< aClass;
		priority: aPriority;
		yourself
]

{ #category : #'as yet unclassified' }
SWType class >> transpile_selfClass: cdt [
	cdt
		senderTranspilerOf: #declare:as: is: [ :mbt |  mbt preventStatementDelimiter; preventNewline ]
]

{ #category : #constants }
SWType class >> userSpecifyingPriority [
	^ 100
]

{ #category : #'accumulator ops' }
SWType >> << rightType [
	rightType ifNil: [ ^ rightType ].
	(rightType class includesBehavior: SWType) ifTrue: [
		rightType priority <= self priority ifTrue: [ ^ rightType ].

		self payload: rightType payload.
		self priority: rightType priority.
	] ifFalse: [
		rightType = UndefinedObject ifTrue: [  ^ rightType ].

		self payload: rightType.
		self priority: nil.
	].
	^ rightType

]

{ #category : #comparing }
SWType >> = right [
	self class = right class ifFalse: [ ^ false ].
	^ self payload = right payload
]

{ #category : #comparing }
SWType >> hash [
	^ self payload hash
]

{ #category : #testing }
SWType >> isContainer [
	^ false
]

{ #category : #accessing }
SWType >> payload [

	^ payload ifNil: [ payload := nil class ]
]

{ #category : #accessing }
SWType >> payload: anObject [

	payload := anObject
]

{ #category : #printing }
SWType >> printOn: aStream [
	self putOn: aStream
]

{ #category : #accessing }
SWType >> priority [

	^ priority ifNil: [ priority := self class calcPriorityOf: self payload ]
]

{ #category : #accessing }
SWType >> priority: anObject [

	priority := anObject
]

{ #category : #streaming }
SWType >> putOn: aStream [
	aStream
		<< payload asString;
		<< $:;
		<< (self class nameOfPriority: self priority)
]

{ #category : #accessing }
SWType >> superclass [
	^ self copy
		payload: self payload superclass;
		yourself
]

{ #category : #accessing }
SWType >> value [
	^ self payload

]
