"
I hold places for variables.
"
Class {
	#name : #SWSlot,
	#superclass : #Object,
	#instVars : [
		'payload'
	],
	#category : #'SWFortranByPharo-Analyzer-Slot'
}

{ #category : #accessing }
SWSlot class >> elementClass [
	^ SWVariableTypeInfo
]

{ #category : #'instance creation' }
SWSlot class >> newFrom: anArray [
	|inst|
	inst := self new.
	anArray doWithIndex: [ :each :idx |
		(inst at: idx) << each
	].
	^ inst
]

{ #category : #comparing }
SWSlot >> = right [
	^ self value = right value
]

{ #category : #'instance creation' }
SWSlot >> allocate: size [
	[ self payload size < size ] whileTrue: [
		self payload add:  self class elementClass new
	]
]

{ #category : #converting }
SWSlot >> asArray [
	^ self payload asArray
]

{ #category : #accessing }
SWSlot >> at: index [
	^ self payload at: index ifAbsentPut: [ self class elementClass new ].
]

{ #category : #accessing }
SWSlot >> atOffset: offset [
	"offset is  0 based.".
	"offset 0 responds to the first argument."
	^ self payload at: (offset + 1) ifAbsentPut: [ SWVariableTypeInfo new ].
]

{ #category : #enumerating }
SWSlot >> collect: anIterator [
	^ self payload collect: anIterator
]

{ #category : #copying }
SWSlot >> copyFrom: start to: end [
	self allocate: end.
	^ self payload copyFrom: start to: end
]

{ #category : #enumerating }
SWSlot >> detect: aNeedle ifFound: foundBlock [
	^ self payload detect: aNeedle ifFound: foundBlock
]

{ #category : #enumerating }
SWSlot >> detect: aNeedle ifFound: foundBlock ifNone: noneBlock [
	^ self payload detect: aNeedle ifFound: foundBlock ifNone: noneBlock
]

{ #category : #enumerating }
SWSlot >> detect: aNeedle ifNone: noneBlock [
	^ self payload detect: aNeedle ifNone: noneBlock
]

{ #category : #enumerating }
SWSlot >> do: aBlock [
	^ self payload do: aBlock
]

{ #category : #enumerating }
SWSlot >> doWithIndex: anIterator [
	^ self payload doWithIndex: anIterator
]

{ #category : #accessing }
SWSlot >> first [
	^ self at: 1
]

{ #category : #accessing }
SWSlot >> payload [

	^ payload ifNil: [ payload := OrderedCollection new ]
]

{ #category : #accessing }
SWSlot >> payload: anObject [

	payload := anObject
]

{ #category : #copying }
SWSlot >> postCopy [
	payload := payload copy
]

{ #category : #printing }
SWSlot >> printOn: aStream [
	self putOn: aStream
]

{ #category : #streaming }
SWSlot >> putOn: aStream [
	aStream << '('.
	self payload do: [ :each |
		aStream << each value asString
	] separatedBy: [
		aStream << ', '
	].
	aStream << ')'
]

{ #category : #accessing }
SWSlot >> receiver [
	^ self at: 1
]

{ #category : #accessing }
SWSlot >> second [
	^ self at: 2
]

{ #category : #accessing }
SWSlot >> size [
	^ self payload size.
]

{ #category : #accessing }
SWSlot >> third [
	^ self at: 3
]

{ #category : #accessing }
SWSlot >> top [
	^ self payload last
]

{ #category : #accessing }
SWSlot >> value [
	^ payload
]
