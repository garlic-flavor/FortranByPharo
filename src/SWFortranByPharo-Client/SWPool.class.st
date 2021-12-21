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

{ #category : #'as yet unclassified' }
SWPool class >> defined_copy [
	^ self returnReceiverOp
]

{ #category : #'instance creation' }
SWPool class >> defined_new [
	^ [ :method :args |
		SWCompiledCodeInfo new
			method: method;
			return: (SWVariableTypeInfo newAs: args first value soleInstance with: args first priority);
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

{ #category : #adding }
SWPool >> addMethodInfo: aMethodInfo [
	|instanceSideClass classinfo|
	self halt.
	instanceSideClass := aMethodInfo method methodClass instanceSide.
	classinfo := self payload at: instanceSideClass ifPresent: [ :ci | ci ] ifAbsent: [ |ci|
		ci :=(instanceSideClass classSide methodDict includesKey: #predefinedClassInfo) ifTrue: [
			instanceSideClass perform: #predefinedClassInfo
		] ifFalse: [
			SWClassInfo new
				targetClass: instanceSideClass;
				pool: self;
				yourself
		].
		self payload at: instanceSideClass put: ci.
		self onClassAdded value: ci.
		ci
	].
	aMethodInfo method methodClass isClassSide ifTrue: [
		classinfo classSide ifNil: [|ci|
			ci := SWClassInfo new
				targetClass: aMethodInfo method methodClass;
				pool: self;
				yourself.
			classinfo classSide: ci.
			self onClassAdded value: ci.
		].
		classinfo := classinfo classSide
	].
	
	^ classinfo addMember: aMethodInfo ifAbsent: [
		self onMethodAdded value: aMethodInfo
	]

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
		self transpilerClass new: aMethodFinder method with: aMethodFinder args
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
