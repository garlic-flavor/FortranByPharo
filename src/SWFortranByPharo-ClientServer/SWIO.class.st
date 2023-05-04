Class {
	#name : #SWIO,
	#superclass : #Stream,
	#instVars : [
		'streams'
	],
	#category : #'SWFortranByPharo-ClientServer-Shell'
}

{ #category : #'instance creation' }
SWIO class >> new [
	^ self basicNew
		initialize;
		yourself
]

{ #category : #'bit manipulation' }
SWIO >> >> aBlock [
	^ self stdin >> aBlock
]

{ #category : #accessing }
SWIO >> at: anInteger [
	^ streams at: anInteger
]

{ #category : #testing }
SWIO >> atEnd [
	"Answer whether the receiver can access any more objects."

	^ self stdin ifNil: [ true ] ifNotNil: [ self stdin atEnd ]
]

{ #category : #testing }
SWIO >> closed [
	self stdin ifNil: [ ^ true ].
	self stdin closed ifTrue: [ ^ true ].
	self stdout ifNil: [ ^ true ].
	self stdout closed ifTrue: [ ^ true ].
]

{ #category : #accessing }
SWIO >> contents [
	"Answer all of the contents of the receiver."

	^ self stdin ifNil: [ nil ] ifNotNil: [ self stdin contents ]
]

{ #category : #running }
SWIO >> done [
	self stdout ifNotNil: [ self stdout done ]
]

{ #category : #initialization }
SWIO >> initialize [
	super initialize.
	streams := OrderedCollection newFrom: { nil. nil. nil }.
]

{ #category : #accessing }
SWIO >> next [
	"Answer the next object accessible by the receiver."

	^ self stdin ifNil: [ nil ] ifNotNil: [ self stdin next ]
]

{ #category : #accessing }
SWIO >> nextPut: anObject [
	"Insert the argument, anObject, as the next object accessible by the
	receiver. Answer anObject."

	self stdout ifNotNil: [ self stdout nextPut: anObject ]
]

{ #category : #accessing }
SWIO >> stderr [
	^ streams at: 3
]

{ #category : #accessing }
SWIO >> stderr: aStream [
	streams at: 3 put: aStream
]

{ #category : #accessing }
SWIO >> stdin [
	^ streams at: 1
]

{ #category : #accessing }
SWIO >> stdin: aStream [
	streams at: 1 put: aStream
]

{ #category : #accessing }
SWIO >> stdout [
	^ streams at: 2
]

{ #category : #accessing }
SWIO >> stdout: aStream [
	streams at: 2 put: aStream
]
