"
I am a pool of SWClassInfo.
"
Class {
	#name : #SWPool,
	#superclass : #Object,
	#instVars : [
		'payload',
		'transpilerClass',
		'onClassAdded',
		'onMethodAdded'
	],
	#category : #'SWFortranByPharo-Client-Analyzer'
}

{ #category : #private }
SWPool class >> binaryOpInfo [
	^ [ :selector :args |
		SWMethodInfo new
			method: selector;
			types: args;
			return: (args first copy
				priority: (SWVariableInfo wellknownMethodPriorityWith: args);
				yourself);
			yourself
	]
]

{ #category : #'instance creation' }
SWPool class >> defined_new [
	^ [ :selector :args |
		SWMethodInfo new
			method: #new;
			return: (SWVariableInfo new
				type: args first type soleInstance;
				priority: {SWVariableInfo wellknownMethodPriority. args first priority} min;
				yourself);
			types: args;
			yourself
	]
]

{ #category : #initialization }
SWPool class >> defined_opEqual_ [
	^ self binaryOpInfo
]

{ #category : #initialization }
SWPool class >> defined_opLT_ [
	^ self binaryOpInfo
]

{ #category : #initialization }
SWPool class >> defined_opMul_ [
	^ self binaryOpInfo
]

{ #category : #initialization }
SWPool class >> defined_opPlus_ [
	^ self binaryOpInfo
]

{ #category : #initialization }
SWPool class >> defined_opSub_ [
	^ self binaryOpInfo
]

{ #category : #'instance creation' }
SWPool class >> defined_yourself [
	^ [ :selector :args |
		SWMethodInfo new
			method: Object>>#yourself;
			return: (SWVariableInfo new
				type: [args first type];
				priority: { SWVariableInfo wellknownMethodPriority. args first priority } min;
				yourself);
			types: args;
			yourself
	]
]

{ #category : #adding }
SWPool >> add: aMethodInfo [
	^ (self payload at: aMethodInfo method methodClass ifPresent: [ :ci | ci ] ifAbsent: [|ci|
		ci := SWClassInfo new
			targetClass: aMethodInfo method methodClass;
			pool: self;
			yourself.
		self payload at: aMethodInfo method methodClass put: ci.
		self onClassAdded value: ci.
		ci.
	]) addMember: aMethodInfo ifAbsent: [
		self onMethodAdded value: aMethodInfo
	]
]

{ #category : #'as yet unclassified' }
SWPool >> definedMethod: aMethodOrSelector ifPresent: presentBlock [
	^ self definedMethod: aMethodOrSelector ifPresent: presentBlock ifAbsent: nil
]

{ #category : #'as yet unclassified' }
SWPool >> definedMethod: aMethodOrSelector ifPresent: presentBlock ifAbsent: absentBlock [
	|generatorSelector selector|
	selector := aMethodOrSelector class = CompiledMethod ifTrue: [ aMethodOrSelector selector ] ifFalse: [ aMethodOrSelector  ].
	generatorSelector := #defined_, (self transpilerClass safeSelectorNameOf: selector).
	^ (self class respondsTo: generatorSelector) ifTrue: [
		presentBlock value: (self class perform: generatorSelector)
	] ifFalse: [
		absentBlock value
	]
]

{ #category : #'instance creation' }
SWPool >> new: aMethodOrSelector with: anArrayOfVariableInfoOrType [
	^ (self definedMethod: aMethodOrSelector ifPresent: [ :mi |
		mi value: aMethodOrSelector value: anArrayOfVariableInfoOrType
	] ifAbsent: [
		self transpilerClass new: aMethodOrSelector with: anArrayOfVariableInfoOrType
	])
		pool: self;
		yourself

]

{ #category : #accessing }
SWPool >> onClassAdded [

	^ onClassAdded ifNil: [ onClassAdded := [ :ci |  ] ]
]

{ #category : #accessing }
SWPool >> onClassAdded: anObject [

	onClassAdded := anObject
]

{ #category : #accessing }
SWPool >> onMethodAdded [

	^ onMethodAdded ifNil: [ onMethodAdded := [ :mi | ] ]
]

{ #category : #accessing }
SWPool >> onMethodAdded: anObject [

	onMethodAdded := anObject
]

{ #category : #accessing }
SWPool >> payload [

	^ payload ifNil: [ payload := Dictionary new ]
]

{ #category : #accessing }
SWPool >> payload: anObject [

	payload := anObject
]

{ #category : #enumerating }
SWPool >> select: aNeedle thenDo: anIterator [
	^ self payload values select: aNeedle thenDo: anIterator
]

{ #category : #accessing }
SWPool >> transpilerClass [

	^ transpilerClass
]

{ #category : #accessing }
SWPool >> transpilerClass: anObject [

	transpilerClass := anObject
]