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

{ #category : #'code generation' }
SWPool class >> defaultTranspilerFor: aSelector [

	aSelector = #at:ifAbsent: ifTrue: [
		^ [:args ||cci|
			cci := (SWCompiledCodeInfo new).
			cci return << (args at: 2).
			cci markAsDecoded.
			cci
		]
	].

	self error.
]

{ #category : #utils }
SWPool class >> search: selector in: aClass [
	aClass ifNil: [ ^ nil ].

	^ aClass methodDict at: selector ifAbsent: [
			self search: selector in: aClass superclass
	]

]

{ #category : #accessing }
SWPool >> classTranspilerClass [

	^ self transpilerClass classTranspilerClass
]

{ #category : #'instance creation' }
SWPool >> newClassTranspiler: aClass [
	^ self payload at: aClass ifAbsentPut: [
		self classTranspilerClass new
			pool: self;
			targetClass: aClass;
			ready;
			yourself.
	]
]

{ #category : #'instance creation' }
SWPool >> newMethodTranspiler: aSelector with: args [
	|method|
	aSelector = #== ifTrue: [ self halt. ].
	method := self class search: aSelector in: args first value.
	^ method ifNotNil: [
		(self newClassTranspiler: method methodClass)
			newMethodTranspiler: method with: args.
	] ifNil: [
		self halt.
		(self class defaultTranspilerFor: aSelector)
			value: args
	]
	

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
