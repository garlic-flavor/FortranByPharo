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
SWVariableInfo class >> exactTypePriority [
	^ 1000
]

{ #category : #private }
SWVariableInfo class >> mangledTypeNameOf: aType [
	^ aType ifNil: [ '_' ] ifNotNil: [ aType name select: [ :c | c isUppercase ] thenCollect: [ :c | c asLowercase ] ].
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

{ #category : #'as yet unclassified' }
SWVariableInfo class >> wellknownMethodPriorityWith: anArrayOfVariableInfo [
	^ { self wellknownMethodPriority. (anArrayOfVariableInfo collect: [:each | each priority ]) min } min
]

{ #category : #'accumulator ops' }
SWVariableInfo >> << rightObject [
	rightObject original ifNil: [
		self priority <= rightObject priority ifTrue: [
			rightObject hasExactType ifTrue: [
				self type: rightObject type
			] ifFalse: [
				self type: [ rightObject type ]
			].
			self class wellknownMethodPriority <= rightObject priority ifTrue: [
				self priority: rightObject priority
			] ifFalse: [
				self priority: nil
			]
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

{ #category : #copying }
SWVariableInfo >> copyAsSuper [
	^ self copy
		type: [ self type superclass ];
		yourself.
]

{ #category : #testing }
SWVariableInfo >> hasAnyType [
	^ type isNotNil
]

{ #category : #testing }
SWVariableInfo >> hasExactType [
	^ type isNotNil and: [ type class ~= FullBlockClosure ]
]

{ #category : #testing }
SWVariableInfo >> hasProperty: aProperty [
	^ self properties includes: aProperty
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
		print: (type class = FullBlockClosure ifTrue: ['lazy'] ifFalse: [ type ]);
		nextPut: $>;
		nextPut: $(;
		print: self priority;
		nextPut: $);
		space;
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
				self class defaultPriority
			] ifNotNil: [
				type class = FullBlockClosure ifTrue: [
					self class unknownMethodPriority
				] ifFalse: [
					type = UndefinedObject ifTrue: [
						self class defaultPriority
					] ifFalse: [
						self class exactTypePriority
					]
				]
			]
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

	^ type := type value
]

{ #category : #accessing }
SWVariableInfo >> type: anObject [

	type := anObject.

]

{ #category : #accessing }
SWVariableInfo >> value [
	^ self type
]
