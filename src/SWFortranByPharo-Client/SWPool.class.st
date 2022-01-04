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
		^ [:args |
			(SWCompiledCodeInfo new)
				return: (SWVariableTypeInfo new: (args at: 2));
				markAsDecoded;
				yourself
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
SWPool >> newMethodTranspiler: aSelector supered: supered with: args [
	|method callee methodClass|

	method := self class search: aSelector
		in: (supered ifTrue: [ args first value superclass ] ifFalse: [ args first value ]).
	callee := SWCalleeInfo new: (method ifNotNil: [ method ] ifNil: [ aSelector ]) with: args.
	methodClass := (method ifNotNil: [ method methodClass ] ifNil: [ UndefinedObject ] ).
	^ (self newClassTranspiler: methodClass)
		newMethodTranspiler: callee

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
