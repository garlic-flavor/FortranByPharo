"
I am in a SWVariableInfo.
"
Class {
	#name : #SWType,
	#superclass : #Object,
	#instVars : [
		'payload',
		'priority'
	],
	#category : #'SWFortranByPharo-Client-Analyzer'
}

{ #category : #'as yet unclassified' }
SWType class >> argumentTypePriority [
	^ 80
]

{ #category : #utils }
SWType class >> calcPriorityOf: aClass [
	aClass ifNil: [ ^ self defaultPriority ].
	aClass = UndefinedObject ifTrue: [ ^ self defaultPriority ].
	aClass class = FullBlockClosure ifTrue: [ ^ self unknownMethodPriority ].
	^ self exactTypePriority 
]

{ #category : #'as yet unclassified' }
SWType class >> declare: aName as: aType [
	^ aName -> (self new
		type: aType;
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

{ #category : #utils }
SWType class >> mangledNameOf: aType [
	^ aType ifNil: [ '_' ] ifNotNil: [ aType name select: [ :c | c isUppercase ] thenCollect: [ :c | c asLowercase ] ].
]

{ #category : #utils }
SWType class >> nameOfPriority: aPriority [
	^ ((self class methodDict values select: [ :m |
		m protocol = #constants
	] thenCollect: [ :m |
		(m valueWithReceiver: self arguments: #()) -> m
	]) sort: [ :a :b | b key < a key ]) detect: [ :m | m key <= aPriority ] ifFound: [ :m |
		m value selector
	] ifNone: [
		#unknown
	]

	
]

{ #category : #'instance creation' }
SWType class >> new: aClass [
	^ self new
		payload: aClass;
		yourself
]

{ #category : #'instance creation' }
SWType class >> new: aClass with: aPriority [
	^ self new
		payload: aClass;
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

{ #category : #streaming }
SWType >> << rightType [
	(rightType class includesBehavior: SWType) ifTrue: [
		rightType priority < self priority ifTrue: [ ^ self ].

		self payload: rightType payload.
		self priority: rightType priority.
	] ifFalse: [
		self payload: rightType.
		self priority: nil.
	]

]

{ #category : #accessing }
SWType >> easyValue [
	^ self class exactTypePriority <= self priority ifTrue: [ self value ] ifFalse: [ nil ]
]

{ #category : #accessing }
SWType >> mangledName [
	^ self class mangledNameOf: self payload
]

{ #category : #accessing }
SWType >> payload [

	^ payload
]

{ #category : #accessing }
SWType >> payload: anObject [

	payload := anObject
]

{ #category : #accessing }
SWType >> priority [

	^ priority ifNil: [ priority := self class calcPriorityOf: self payload ]
]

{ #category : #accessing }
SWType >> priority: anObject [

	priority := anObject
]

{ #category : #printing }
SWType >> putOn: aStream [
	aStream
		<< (payload class = FullBlockClosure ifTrue: ['lazy'] ifFalse: [ payload asString ]);
		<< $:;
		<< (self class nameOfPriority: self priority)
]

{ #category : #accessing }
SWType >> value [
	^ payload := payload value
]
