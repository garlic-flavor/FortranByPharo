"
I am in a SWVariableInfo.
I can be used to declare the type of a variable.
---
    SWType declare: #nameOfVariable as: Integer.
---

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
	aClass class = FullBlockClosure ifTrue: [ ^ self unknownMethodPriority ].
	^ self exactTypePriority 
]

{ #category : #api }
SWType class >> declare: aName as: aType [

	^ aName -> (SWVariableTypeInfo new
		<< aType;
		priority: self userSpecifyingPriority;
		yourself)
]

{ #category : #constants }
SWType class >> defaultPriority [
	^ 0
]

{ #category : #constants }
SWType class >> exactTypePriority [
	^ 90
]

{ #category : #initialization }
SWType class >> initializeClassSideTranspiler: transpiler [
	transpiler
		defineMethod: #declare:as: as: [ :newT |
			newT
				specifyReturnTypeAs: SWVariableTypeInfo;
				senderGenerator: [ :t :node |
					t preventStatementDelimiter; preventNewline
				];
				yourself
		]
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

{ #category : #constants }
SWType class >> receiverTypePriority [
	^ 60
]

{ #category : #constants }
SWType class >> unknownMethodPriority [
	^ 70
]

{ #category : #constants }
SWType class >> userSpecifyingPriority [
	^ 100
]

{ #category : #'accumulator ops' }
SWType >> << rightType [
	rightType ifNil: [ ^ self ].
	(rightType class includesBehavior: SWType) ifTrue: [
		rightType priority <= self priority ifTrue: [ ^ self ].

		self payload: rightType payload.
		self priority: rightType priority.
	] ifFalse: [
		rightType = UndefinedObject ifTrue: [  ^ self ].

		self payload: rightType.
		self priority: nil.
	]

]

{ #category : #comparing }
SWType >> = right [
	^ self payload = right payload
]

{ #category : #accessing }
SWType >> easyValue [
	^ self class exactTypePriority <= self priority ifTrue: [ self value ] ifFalse: [ nil ]
]

{ #category : #comparing }
SWType >> hash [
	^ self payload hash
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
		<< (payload isBlock ifTrue: ['lazy'] ifFalse: [ payload asString ]);
		<< $:;
		<< (self class nameOfPriority: self priority)
]

{ #category : #accessing }
SWType >> value [
	^ payload isBlock ifTrue: [
		priority := nil.
		payload := payload value
	] ifFalse: [
		self payload
	].

]
