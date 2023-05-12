Class {
	#name : #SWStd,
	#superclass : #Stream,
	#instVars : [
		'streams',
		'pipes',
		'semaphore'
	],
	#category : #'SWFortranByPharo-ClientServer-Shell'
}

{ #category : #'instance creation' }
SWStd class >> new [
	^ self basicNew
		initialize;
		yourself
]

{ #category : #'bit manipulation' }
SWStd >> >> aBlock [
	^ self in >> aBlock
]

{ #category : #accessing }
SWStd >> at: anInteger [
	^ streams at: anInteger
]

{ #category : #testing }
SWStd >> atEnd [
	"Answer whether the receiver can access any more objects."

	^ self in ifNil: [ true ] ifNotNil: [ self in atEnd ]
]

{ #category : #testing }
SWStd >> closed [
	self in ifNil: [ ^ true ].
	self in closed ifTrue: [ ^ true ].
	self out ifNil: [ ^ true ].
	self out closed ifTrue: [ ^ true ].
]

{ #category : #accessing }
SWStd >> contents [
	"Answer all of the contents of the receiver."

	^ self in ifNil: [ nil ] ifNotNil: [ self in contents ]
]

{ #category : #running }
SWStd >> done [
	self out ifNotNil: [ self out done ]
]

{ #category : #accessing }
SWStd >> err [
	^ streams at: 3
]

{ #category : #accessing }
SWStd >> err: aStream [
	streams at: 3 put: aStream
]

{ #category : #accessing }
SWStd >> in [
	^ streams at: 1
]

{ #category : #accessing }
SWStd >> in: aStream [
	streams at: 1 put: aStream
]

{ #category : #initialization }
SWStd >> initialize [
	super initialize.
	streams := OrderedCollection newFrom: { nil. nil. nil }.

]

{ #category : #'instance creation' }
SWStd >> newPipe [
	^ self pipes add: SWPipe new
]

{ #category : #accessing }
SWStd >> next [
	"Answer the next object accessible by the receiver."

	^ self in ifNil: [ nil ] ifNotNil: [ self in next ]
]

{ #category : #accessing }
SWStd >> nextPut: anObject [
	"Insert the argument, anObject, as the next object accessible by the
	receiver. Answer anObject."

	self out ifNotNil: [ self out nextPut: anObject ]
]

{ #category : #accessing }
SWStd >> out [
	^ streams at: 2
]

{ #category : #accessing }
SWStd >> out: aStream [
	streams at: 2 put: aStream
]

{ #category : #accessing }
SWStd >> pipes [

	^ pipes ifNil: [ pipes := OrderedCollection new ]
]

{ #category : #accessing }
SWStd >> pipes: anObject [

	pipes := anObject
]

{ #category : #accessing }
SWStd >> readStream [
	^ self in
]

{ #category : #accessing }
SWStd >> semaphore [
	^ semaphore ifNil: [ semaphore := Semaphore new ]
]

{ #category : #accessing }
SWStd >> sub [
	^ self class new
		pipes: self pipes;
		yourself.
]

{ #category : #waiting }
SWStd >> wait [
	0 < self pipes size ifTrue: [
		(self pipes size + 1) timesRepeat: [
			self semaphore wait
		]
	]

]

{ #category : #writing }
SWStd >> writeStream [
	^ self out
]
