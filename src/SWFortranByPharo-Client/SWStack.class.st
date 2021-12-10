"
I emulate stack like a stack in Context.
index -1 indicates the type of the recevier.
index 0 indicates the first argument of the method.
"
Class {
	#name : #SWStack,
	#superclass : #Object,
	#instVars : [
		'payload'
	],
	#category : #'SWFortranByPharo-Client-Analyzer'
}

{ #category : #'instance creation' }
SWStack class >> newFrom: anArray [
	|s|
	s := self new.
	anArray do: [ :each | s push: each ].
	^ s
]

{ #category : #converting }
SWStack >> asArray [
	^ self payload asArray
]

{ #category : #accessing }
SWStack >> at: index [
	"index is 1 based.".
	"index 0 responds special to receiver."
	^ self payload at: (index + 1) ifAbsent: [ nil ].
]

{ #category : #accessing }
SWStack >> atOffset: offset [
	"offset is  0 based.".
	"offset 0 responds to the first argument."
	^ self payload at: (offset + 2) ifAbsent: [ nil ].
]

{ #category : #accessing }
SWStack >> atOffset: offset put: anObject [
	"offset is  0 based.".
	"offset 0 responds to the first argument."
	^ self payload at: (offset + 2) put: anObject.
]

{ #category : #copying }
SWStack >> copyFrom: start to: end [
	^ self payload copyFrom: start + 1 to: end + 1
]

{ #category : #enumerating }
SWStack >> detect: needle ifNone: noneBlock [
	^ self payload detect: needle ifNone: noneBlock
]

{ #category : #accessing }
SWStack >> payload [

	^ payload ifNil: [ payload := OrderedCollection new ]
]

{ #category : #accessing }
SWStack >> payload: anObject [

	payload := anObject
]

{ #category : #removing }
SWStack >> pop [
	^ self payload removeLast.
]

{ #category : #affecting }
SWStack >> pop: itemsCount [
	|arr|
	arr := OrderedCollection new.
	itemsCount timesRepeat: [
		arr addFirst: self pop.
	].
	^ arr
]

{ #category : #adding }
SWStack >> push: anObject [
	^ self payload addLast: anObject.
]

{ #category : #'as yet unclassified' }
SWStack >> push: anObject afterIndex: idx [
	^ self payload add: anObject afterIndex: (idx + 1)
]

{ #category : #accessing }
SWStack >> size [
	^ self payload size.
]

{ #category : #accessing }
SWStack >> top [
	^ self payload last
]
