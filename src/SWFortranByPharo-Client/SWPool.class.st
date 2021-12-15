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

{ #category : #'instance creation' }
SWPool >> new: selector types: args [
	|methodInfo classInfo|
	methodInfo := self transpilerClass new: selector types: args.
	methodInfo pool: self.
	classInfo := self payload at: methodInfo method methodClass ifAbsentPut: [
		SWClassInfo new
			targetClass: methodInfo method methodClass;
			yourself
	].
	^ classInfo addMember: methodInfo ifAbsent: [
		methodInfo ready
"
		classInfo isToTranspile ifTrue: [
			methodInfo ready
		]
"
	].

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
