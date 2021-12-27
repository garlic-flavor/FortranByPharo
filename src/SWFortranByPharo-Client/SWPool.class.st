"
I am a pool of SWClassInfo.
"
Class {
	#name : #SWPool,
	#superclass : #Object,
	#instVars : [
		'payload',
		'transpilerClass'
	],
	#category : #'SWFortranByPharo-Client-Analyzer'
}

{ #category : #'as yet unclassified' }
SWPool class >> defined_copy [
	^ self returnReceiverOp
]

{ #category : #'as yet unclassified' }
SWPool class >> defined_default [
	^ self defined_new
]

{ #category : #'instance creation' }
SWPool class >> defined_new [
	^ [ :args |
		SWWellknownMethodInfo new
			return: (SWVariableTypeInfo new: [ args first value soleInstance ] with: args first priority);
			yourself
	]
]

{ #category : #initialization }
SWPool class >> defined_opEqual_ [
	^ self returnReceiverOp
]

{ #category : #initialization }
SWPool class >> defined_opLT_ [
	^ self returnReceiverOp
]

{ #category : #initialization }
SWPool class >> defined_opMul_ [
	^ self returnReceiverOp
]

{ #category : #initialization }
SWPool class >> defined_opPlus_ [
	^ self returnReceiverOp
]

{ #category : #initialization }
SWPool class >> defined_opSub_ [
	^ self returnReceiverOp
]

{ #category : #'instance creation' }
SWPool class >> defined_yourself [
	^ self returnReceiverOp
]

{ #category : #'instance creation' }
SWPool class >> returnReceiverOp [
	^ [ :args |
		SWWellknownMethodInfo new
			return: args first;
			yourself
	]
]

{ #category : #utils }
SWPool class >> search: selector in: aClass [
	aClass ifNil: [ self error ].

	^ aClass methodDict at: selector ifAbsent: [
			self search: selector in: aClass superclass
	]

]

{ #category : #accessing }
SWPool >> classTranspilerClass [

	^ self transpilerClass classTranspilerClass
]

{ #category : #'as yet unclassified' }
SWPool >> definedMethod: selector ifPresent: presentBlock ifAbsent: absentBlock [
	|generatorSelector|

	generatorSelector := #defined_, (self transpilerClass mangleClass safeSelectorNameOf: selector).
	^ (self class respondsTo: generatorSelector) ifTrue: [
		presentBlock value: (self class perform: generatorSelector)
	] ifFalse: [
		absentBlock value
	]

]

{ #category : #'instance creation' }
SWPool >> newClassTranspiler: aClass [
	|initializer|
	initializer := #initializeClassTranspiler:.
	^ self payload at: aClass ifAbsentPut: [|ct|
		ct := self classTranspilerClass new
			targetClass: aClass;
			pool: self;
			yourself.
		aClass = Behavior ifTrue: [ self halt ].
		(aClass classSide methodDict includesKey: initializer) ifTrue: [
			(aClass classSide >> initializer) valueWithReceiver: aClass arguments: { ct }
		].
		ct
	]
]

{ #category : #'instance creation' }
SWPool >> newMethodTranspiler: aSelector with: args [
	|method|
	method := self class search: aSelector in: args first value.
	^ (self newClassTranspiler: method methodClass)
		method: method with: args.
"
	^ self definedMethod: aSelector ifPresent: [ :mi |
		mi value: args
	] ifAbsent: [|method|
		method := self class search: aSelector in: args first value.
		(self newClassTranspiler: method methodClass)
			method: method with: args
	]
"
]

{ #category : #accessing }
SWPool >> payload [

	^ payload ifNil: [ payload := Dictionary new ]
]

{ #category : #accessing }
SWPool >> payload: anObject [

	payload := anObject
]

{ #category : #printing }
SWPool >> printOn: aStream [
	self putOn: aStream.
]

{ #category : #streaming }
SWPool >> putOn: aStream [
	aStream << (self hash % 16rFFFF) printStringHex
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
