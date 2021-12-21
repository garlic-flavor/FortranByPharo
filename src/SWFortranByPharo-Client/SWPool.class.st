"
I am a pool of SWClassInfo.
"
Class {
	#name : #SWPool,
	#superclass : #Object,
	#instVars : [
		'payload',
		'transpilerClass',
		'classTranspilerClass'
	],
	#category : #'SWFortranByPharo-Client-Analyzer'
}

{ #category : #'as yet unclassified' }
SWPool class >> defined_copy [
	^ self returnReceiverOp
]

{ #category : #'instance creation' }
SWPool class >> defined_new [
	^ [ :method :args |
		SWCompiledCodeInfo new
			method: method;
			return: (SWVariableTypeInfo new: args first value soleInstance with: args first priority);
			types: args;
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
	^ [ :method :args |
		SWCompiledCodeInfo new
			method: method;
			return: args first;
			types: args;
			yourself
	]
]

{ #category : #accessing }
SWPool >> classInfo: aClass [
	^ self payload at: aClass name ifAbsentPut: [
		self classTranspilerClass new
			transpilerClass: self transpilerClass;
			targetClass: aClass;
			yourself
	]
]

{ #category : #accessing }
SWPool >> classTranspiler: aClass [
	^ aClass isClassSide ifTrue: [|ci|
		ci := self classTranspiler: aClass instanceSide.
		ci classSide ifNil: [ ci classSide: (self newClassTranspiler: aClass) ]
	] ifFalse: [
		self payload at: aClass name ifAbsentPut: [
			self newClassTranspiler: aClass
		]
	]
]

{ #category : #accessing }
SWPool >> classTranspilerClass [

	^ classTranspilerClass
]

{ #category : #accessing }
SWPool >> classTranspilerClass: anObject [

	classTranspilerClass := anObject
]

{ #category : #'as yet unclassified' }
SWPool >> definedMethod: selector ifPresent: presentBlock ifAbsent: absentBlock [
	|generatorSelector|

	generatorSelector := #defined_, (self transpilerClass safeSelectorNameOf: selector).
	^ (self class respondsTo: generatorSelector) ifTrue: [
		presentBlock value: (self class perform: generatorSelector)
	] ifFalse: [
		absentBlock value
	]

]

{ #category : #'instance creation' }
SWPool >> new: aMethodFinder [
	^ (self definedMethod: aMethodFinder selector ifPresent: [ :mi |
		mi value: aMethodFinder method value: aMethodFinder args
	] ifAbsent: [
		(self classInfo: aMethodFinder method methodClass) method: aMethodFinder selector
	])
		pool: self;
		yourself

]

{ #category : #'instance creation' }
SWPool >> newClassTranspiler: aClass [
	|ct|
	ct := self classTranspilerClass new
		targetClass: aClass;
		transpilerClass: self transpilerClass;
		yourself.
	(aClass classSide respondsTo: #initializeClassInfo:) ifTrue: [
		aClass classSide perform: #initializeClassInfo: with: ct.
	].
	^ ct
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
