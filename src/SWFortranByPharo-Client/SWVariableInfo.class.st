"
I have an information about a variable.
about, its type, const or not, and other properties.
"
Class {
	#name : #SWVariableInfo,
	#superclass : #Object,
	#instVars : [
		'stackPos',
		'name',
		'type',
		'properties',
		'original',
		'initializer',
		'assignCounter',
		'priority'
	],
	#category : #'SWFortranByPharo-Client-Analyzer'
}

{ #category : #constants }
SWVariableInfo class >> defaultPriority [
	^ 0
]

{ #category : #constants }
SWVariableInfo class >> defaultReturnTypePriority [
	^ 500
]

{ #category : #constants }
SWVariableInfo class >> exactTypePriority [
	^ 1000
]

{ #category : #private }
SWVariableInfo class >> mangledTypeNameOf: aType [
	^ aType name select: [ :c | c isUppercase ] thenCollect: [ :c | c asLowercase ].
]

{ #category : #initialization }
SWVariableInfo class >> named: aName typed: aType [
	^ self new
		name: aName;
		type: aType;
		yourself
]

{ #category : #utils }
SWVariableInfo class >> nextTemporalVariableNameOf: prevName [
	^ prevName isEmptyOrNil ifTrue: [
		'a'
	] ifFalse: [|counter|
		counter := prevName last.
		counter := Character value: counter charCode + 1.
		(counter between: $a and: $z) ifTrue: [
			(prevName copyFrom: 1 to: prevName size - 1), counter asString
		] ifFalse: [
			(self nextTemporalVariableNameOf: (prevName copyFrom: 1 to: prevName size - 1)), 'a'
		]
	].
]

{ #category : #constants }
SWVariableInfo class >> receiverTypePriority [
	^ 600
]

{ #category : #constants }
SWVariableInfo class >> toTranspileMethodPriority [
	^ 800
]

{ #category : #constants }
SWVariableInfo class >> unknownMethodPriority [
	^ 700
]

{ #category : #constants }
SWVariableInfo class >> userSpecifiesTypePriority [
	^ 2000
]

{ #category : #constants }
SWVariableInfo class >> wellknownMethodPriority [
	^ 900
]

{ #category : #'accumulator ops' }
SWVariableInfo >> << rightObject [
	rightObject original ifNil: [
		self priority <= rightObject priority ifTrue: [
			rightObject hasExactType ifTrue: [
				self type: rightObject type
			] ifFalse: [
				self initializer: [ rightObject type ]
			].
			self priority: rightObject priority
		].
		self original: (rightObject stackPos ifNotNil: [rightObject] ifNil: [nil]).
		self properties addAll: rightObject properties.
		self assignCounter: self assignCounter + 1
	] ifNotNil: [
		self << rightObject original
	]
		

]

{ #category : #adding }
SWVariableInfo >> addProperty: aProp [
	self properties add: aProp
]

{ #category : #accessing }
SWVariableInfo >> assignCounter [

	^ assignCounter ifNil: [ assignCounter := 0 ]
]

{ #category : #accessing }
SWVariableInfo >> assignCounter: anObject [

	assignCounter := anObject
]

{ #category : #testing }
SWVariableInfo >> hasAnyType [
	^ type isNotNil or: [ initializer isNotNil ]
]

{ #category : #testing }
SWVariableInfo >> hasExactType [
	^ type isNotNil
]

{ #category : #testing }
SWVariableInfo >> hasProperty: aProperty [
	^ self properties includes: aProperty
]

{ #category : #accessing }
SWVariableInfo >> initializer [

	^ initializer
]

{ #category : #accessing }
SWVariableInfo >> initializer: anObject [

	initializer := anObject.
	self type: nil
]

{ #category : #testing }
SWVariableInfo >> isReceiver [
	^ self stackPos = 0
]

{ #category : #accessing }
SWVariableInfo >> mangledTypeName [
	^ self class mangledTypeNameOf: self type
]

{ #category : #accessing }
SWVariableInfo >> name [
	^ name
]

{ #category : #accessing }
SWVariableInfo >> name: aName [
	name := aName
]

{ #category : #accessing }
SWVariableInfo >> original [

	^ original
]

{ #category : #accessing }
SWVariableInfo >> original: anObject [

	original := anObject
]

{ #category : #printing }
SWVariableInfo >> printOn: aStream [
	aStream
		nextPut: $[;
		print: stackPos;
		nextPut: $];
		space;
		print: name;
		space;
		nextPut: $<;
		print: type;
		nextPut: $>;
		nextPut: $(;
		print: self priority;
		nextPut: $);
		space;
		nextPutAll: (initializer ifNotNil: [ ' [lazy]' ] ifNil: [ '-' ] );
		space;
		nextPutAll: '<<';
		print: assignCounter
]

{ #category : #accessing }
SWVariableInfo >> priority [

	^ priority ifNil: [ 
		priority := stackPos = 0 ifTrue: [
			self class receiverTypePriority
		] ifFalse: [ 
			type ifNil: [ 
				initializer ifNil: [ self class defaultPriority ]
				ifNotNil: [ self class unknownMethodPriority ]
			] ifNotNil: [ self class exactTypePriority ]
		]
	]

]

{ #category : #accessing }
SWVariableInfo >> priority: anObject [

	priority := anObject
]

{ #category : #accessing }
SWVariableInfo >> properties [

	^ properties ifNil: [ properties := Set new ]
]

{ #category : #accessing }
SWVariableInfo >> properties: anObject [

	properties := anObject
]

{ #category : #accessing }
SWVariableInfo >> property: propName [
	^ self properties at: propName ifAbsent: nil
]

{ #category : #removing }
SWVariableInfo >> removeProperty: propName [
	properties remove: propName ifAbsent: [  ].
]

{ #category : #accessing }
SWVariableInfo >> stackPos [

	^ stackPos
]

{ #category : #accessing }
SWVariableInfo >> stackPos: anObject [

	stackPos := anObject
]

{ #category : #accessing }
SWVariableInfo >> type [

	^ type ifNil: [
		self initializer ifNotNil: [
			type := self initializer value
		] ifNil: [ 
			nil
		]
	]
]

{ #category : #accessing }
SWVariableInfo >> type: anObject [

	anObject ifNotNil: [ self initializer: nil ].
	type := anObject.

]
