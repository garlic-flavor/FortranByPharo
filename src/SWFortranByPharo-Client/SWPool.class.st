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

{ #category : #'instance creation' }
SWPool >> newClassTranspiler: aClass [
	|initializer|
	initializer := #initializeClassTranspiler:.
	^ self payload at: aClass ifAbsentPut: [|ct|
		ct := self classTranspilerClass new
			targetClass: aClass;
			pool: self;
			yourself.

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
