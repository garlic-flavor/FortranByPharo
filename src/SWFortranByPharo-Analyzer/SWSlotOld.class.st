"
I hold places for variables.
"
Class {
	#name : #SWSlotOld,
	#superclass : #Object,
	#instVars : [
		'payload'
	],
	#category : #'SWFortranByPharo-Analyzer-Olds'
}

{ #category : #accessing }
SWSlotOld class >> elementClass [
	^ SWVariable
]

{ #category : #'instance creation' }
SWSlotOld class >> newFrom: anArray [
	|inst|
	inst := self new.
	anArray doWithIndex: [ :each :idx |
		(inst at: idx) << each
	].
	^ inst
]

{ #category : #comparing }
SWSlotOld >> = right [
	^ self value = right value
]

{ #category : #'instance creation' }
SWSlotOld >> allocate: size [
	[ self payload size < size ] whileTrue: [
		self payload add:  self class elementClass new
	]
]

{ #category : #converting }
SWSlotOld >> asArray [
	^ self payload asArray
]

{ #category : #accessing }
SWSlotOld >> at: index [
	^ self payload at: index ifAbsentPut: [ self class elementClass new ].
]

{ #category : #accessing }
SWSlotOld >> atOffset: offset [
	"offset is  0 based.".
	"offset 0 responds to the first argument."
	^ self payload at: (offset + 1) ifAbsentPut: [ SWVariable new ].
]

{ #category : #enumerating }
SWSlotOld >> collect: anIterator [
	^ self payload collect: anIterator
]

{ #category : #copying }
SWSlotOld >> copyFrom: start to: end [
	self allocate: end.
	^ self payload copyFrom: start to: end
]

{ #category : #enumerating }
SWSlotOld >> detect: aNeedle ifFound: foundBlock [
	^ self payload detect: aNeedle ifFound: foundBlock
]

{ #category : #enumerating }
SWSlotOld >> detect: aNeedle ifFound: foundBlock ifNone: noneBlock [
	^ self payload detect: aNeedle ifFound: foundBlock ifNone: noneBlock
]

{ #category : #enumerating }
SWSlotOld >> detect: aNeedle ifNone: noneBlock [
	^ self payload detect: aNeedle ifNone: noneBlock
]

{ #category : #enumerating }
SWSlotOld >> do: aBlock [
	^ self payload do: aBlock
]

{ #category : #enumerating }
SWSlotOld >> doWithIndex: anIterator [
	^ self payload doWithIndex: anIterator
]

{ #category : #accessing }
SWSlotOld >> first [
	^ self at: 1
]

{ #category : #accessing }
SWSlotOld >> payload [

	^ payload ifNil: [ payload := OrderedCollection new ]
]

{ #category : #accessing }
SWSlotOld >> payload: anObject [

	payload := anObject
]

{ #category : #removing }
SWSlotOld >> pop [
	^ self payload removeLast
]

{ #category : #affecting }
SWSlotOld >> pop: itemsCount [
	|arr|
	arr := self payload copyFrom: self payload size - itemsCount + 1 to: self payload size.
	itemsCount timesRepeat: [ self pop ].
	^ arr
]

{ #category : #copying }
SWSlotOld >> postCopy [
	super postCopy.
	payload := payload copy
]

{ #category : #printing }
SWSlotOld >> printOn: aStream [
	self putOn: aStream
]

{ #category : #adding }
SWSlotOld >> push: anObject [
	^ self payload addLast: anObject.
]

{ #category : #streaming }
SWSlotOld >> putOn: aStream [
	aStream << '('.
	self payload do: [ :each |
		aStream << each value asString
	] separatedBy: [
		aStream << ', '
	].
	aStream << ')'
]

{ #category : #accessing }
SWSlotOld >> receiver [
	^ self at: 1
]

{ #category : #accessing }
SWSlotOld >> second [
	^ self at: 2
]

{ #category : #accessing }
SWSlotOld >> size [
	^ self payload size.
]

{ #category : #accessing }
SWSlotOld >> third [
	^ self at: 3
]

{ #category : #accessing }
SWSlotOld >> top [
	^ self payload last
]

{ #category : #accessing }
SWSlotOld >> value [
	^ payload
]
