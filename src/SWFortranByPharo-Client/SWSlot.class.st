"
I hold places for variables.
"
Class {
	#name : #SWSlot,
	#superclass : #Object,
	#instVars : [
		'payload'
	],
	#category : #'SWFortranByPharo-Client-Analyzer'
}

{ #category : #'instance creation' }
SWSlot >> allocate: size [
	[ self payload size < size ] whileTrue: [
		self payload add: SWVariableInfo new
	]
]

{ #category : #converting }
SWSlot >> asArray [
	^ self payload asArray
]

{ #category : #accessing }
SWSlot >> at: index [
	^ self payload at: index ifAbsentPut: [ SWVariableInfo new ].
]

{ #category : #accessing }
SWSlot >> atOffset: offset [
	"offset is  0 based.".
	"offset 0 responds to the first argument."
	^ self payload at: (offset + 1) ifAbsentPut: [ SWVariableInfo new ].
]

{ #category : #enumerating }
SWSlot >> detect: aNeedle [
	^ self payload detect: aNeedle
]

{ #category : #enumerating }
SWSlot >> detect: needle ifNone: noneBlock [
	^ self payload detect: needle ifNone: noneBlock
]

{ #category : #accessing }
SWSlot >> first [
	^ payload first
]

{ #category : #accessing }
SWSlot >> payload [

	^ payload ifNil: [ payload := OrderedCollection new ]
]

{ #category : #accessing }
SWSlot >> payload: anObject [

	payload := anObject
]

{ #category : #accessing }
SWSlot >> size [
	^ self payload size.
]

{ #category : #accessing }
SWSlot >> top [
	^ self payload last
]
