"
I am a pool of SWClassInfo.
"
Class {
	#name : #SWPool,
	#superclass : #Object,
	#instVars : [
		'payload',
		'transpilerClass',
		'debugMode'
	],
	#category : #'SWFortranByPharo-Analyzer-Analyzer'
}

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

{ #category : #accessing }
SWPool >> debugMode [

	^ debugMode
]

{ #category : #accessing }
SWPool >> debugMode: anObject [

	debugMode := anObject
]

{ #category : #'as yet unclassified' }
SWPool >> detect: aNeedle ifFound: aBlock ifNone: aNoneBlock [
	^ self payload detect: aNeedle ifFound: aBlock ifNone: aNoneBlock
]

{ #category : #'instance creation' }
SWPool >> getClassTranspiler: aClass [
	^ (aClass isClassSide ifTrue: [
		(self getClassTranspiler: aClass instanceSide) classSide
	] ifFalse: [
		self payload at: aClass ifAbsentPut: [ self classTranspilerClass new ]
	])
		pool: self;
		targetClass: aClass;
		yourself

]

{ #category : #'instance creation' }
SWPool >> getMethodTranspiler: aSelector supered: supered with: args [
	|method callee methodClass|

	method := self class search: aSelector
		in: (supered ifTrue: [ args first value superclass ] ifFalse: [ args first value ]).

	callee := SWCalleeInfo new: (method ifNotNil: [ method ] ifNil: [ aSelector ]) with: args.
	methodClass := (method ifNotNil: [ method methodClass ] ifNil: [ UndefinedObject ] ).
	^ (self getClassTranspiler: methodClass)
		getMethodTranspiler: callee

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
	aStream << $#; << (self hash % 16rFFFF) printStringHex
]

{ #category : #enumerating }
SWPool >> select: aNeedle thenDo: anIterator [
self error; flag: #toRemove.
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
