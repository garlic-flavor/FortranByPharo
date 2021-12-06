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
SWVariableInfo class >> mangledTypeNameOf: arg1 [

	^ arg1 name
		  select: [ :arg2 | arg2 isUppercase ]
		  thenCollect: [ :arg3 | arg3 asLowercase ]
]

{ #category : #initialization }
SWVariableInfo class >> named: arg1 typed: arg2 [

	| tmp2 |
	tmp2 := self new.
	tmp2
		name: arg1;
		type: arg2.
	^ tmp2 yourself
]

{ #category : #utils }
SWVariableInfo class >> nextTemporalVariableNameOf: arg1 [

	| tmp1 |
	^ arg1 isEmptyOrNil
		  ifTrue: [ 'a' ]
		  ifFalse: [ 
			  tmp1 := arg1 last.
			  tmp1 := Character value: tmp1 charCode + 1.
			  (tmp1 between: $a and: $z)
				  ifTrue: [ (arg1 copyFrom: 1 to: arg1 size - 1) , tmp1 asString ]
				  ifFalse: [ 
					  (self nextTemporalVariableNameOf:
						   (arg1 copyFrom: 1 to: arg1 size - 1)) , 'a' ] ]
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
SWVariableInfo >> << arg1 [

	arg1 original
		ifNil: [ 
			self priority <= arg1 priority ifTrue: [ 
				arg1 hasExactType
					ifTrue: [ self type: arg1 type ]
					ifFalse: [ self initializer: [ arg1 type ] ].
				self priority: arg1 priority ].
			self original: (arg1 stackPos ifNotNil: [ arg1 ]).
			self properties addAll: arg1 properties.
			self assignCounter: self assignCounter + 1 ]
		ifNotNil: [ self << arg1 original ]
]

{ #category : #adding }
SWVariableInfo >> addProperty: arg1 [

	self properties add: arg1
]

{ #category : #accessing }
SWVariableInfo >> assignCounter [

	^ assignCounter
		  ifNil: [ assignCounter := 0 ]
		  ifNotNil: [ assignCounter ]
]

{ #category : #accessing }
SWVariableInfo >> assignCounter: arg1 [

	assignCounter := arg1
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
SWVariableInfo >> hasProperty: arg1 [

	^ self properties includes: arg1
]

{ #category : #accessing }
SWVariableInfo >> initializer [

	^ initializer
]

{ #category : #accessing }
SWVariableInfo >> initializer: arg1 [

	initializer := arg1.
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
SWVariableInfo >> name: arg1 [

	name := arg1
]

{ #category : #accessing }
SWVariableInfo >> original [

	^ original
]

{ #category : #accessing }
SWVariableInfo >> original: arg1 [

	original := arg1
]

{ #category : #printing }
SWVariableInfo >> printOn: arg1 [

	arg1
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
		nextPutAll: (initializer ifNil: [ '-' ] ifNotNil: [ ' [lazy]' ]);
		space;
		nextPutAll: '<<';
		print: assignCounter
]

{ #category : #accessing }
SWVariableInfo >> priority [

	^ priority
		  ifNil: [ 
			  priority := stackPos = 0
				              ifTrue: [ self class receiverTypePriority ]
				              ifFalse: [ 
					              type
						              ifNil: [ 
							              initializer
								              ifNil: [ self class defaultPriority ]
								              ifNotNil: [ self class unknownMethodPriority ] ]
						              ifNotNil: [ self class exactTypePriority ] ] ]
		  ifNotNil: [ priority ]
]

{ #category : #accessing }
SWVariableInfo >> priority: arg1 [

	priority := arg1
]

{ #category : #accessing }
SWVariableInfo >> properties [

	^ properties
		  ifNil: [ properties := Set new ]
		  ifNotNil: [ properties ]
]

{ #category : #accessing }
SWVariableInfo >> properties: arg1 [

	properties := arg1
]

{ #category : #accessing }
SWVariableInfo >> property: arg1 [

	^ self properties at: arg1 ifAbsent: nil
]

{ #category : #removing }
SWVariableInfo >> removeProperty: arg1 [

	properties remove: arg1 ifAbsent: [  ]
]

{ #category : #accessing }
SWVariableInfo >> stackPos [

	^ stackPos
]

{ #category : #accessing }
SWVariableInfo >> stackPos: arg1 [

	stackPos := arg1
]

{ #category : #accessing }
SWVariableInfo >> type [

	^ type
		  ifNil: [ 
		  self initializer ifNotNil: [ type := self initializer value ] ]
		  ifNotNil: [ type ]
]

{ #category : #accessing }
SWVariableInfo >> type: arg1 [

	arg1 ifNotNil: [ self initializer: nil ].
	type := arg1
]
