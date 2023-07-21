Class {
	#name : #SWPipeReaderWriter,
	#superclass : #Stream,
	#instVars : [
		'collection',
		'semaphoreForWait',
		'semaphoreForDone',
		'semaphoreForAccess',
		'closed'
	],
	#classInstVars : [
		'lineSep'
	],
	#category : #'SWFortranByPharo-ClientServer-Shell'
}

{ #category : #'as yet unclassified' }
SWPipeReaderWriter class >> clearLineSep [
	lineSep := nil
]

{ #category : #accessing }
SWPipeReaderWriter class >> lineSep [
	^ lineSep ifNil: [ lineSep := Character cr ]
]

{ #category : #'instance creation' }
SWPipeReaderWriter class >> new [
	^ self basicNew
		initialize;
		yourself
]

{ #category : #testing }
SWPipeReaderWriter >> atEnd [
	"Answer whether the receiver can access any more objects."

	^ self isEmpty
]

{ #category : #'open/close' }
SWPipeReaderWriter >> close [
	closed ifTrue: [ ^ self ].
	self done.
	closed := true.

]

{ #category : #testing }
SWPipeReaderWriter >> closed [
	^ closed
]

{ #category : #accessing }
SWPipeReaderWriter >> collection [

	^ collection ifNil: [ collection := OrderedCollection new ]
]

{ #category : #accessing }
SWPipeReaderWriter >> collection: anObject [

	collection := anObject
]

{ #category : #accessing }
SWPipeReaderWriter >> contents [
	"Answer all of the contents of the receiver."
	closed ifTrue: [ ^ nil ].
	^ self semaphoreForAccess critical: [ self collection copy ]
]

{ #category : #running }
SWPipeReaderWriter >> done [
	self semaphoreForWait initSignals.
	self semaphoreForDone isSignaled ifTrue: [ ^ self ].
	self semaphoreForDone signal.


]

{ #category : #initialization }
SWPipeReaderWriter >> initialize [
	super initialize.
	closed := false
]

{ #category : #testing }
SWPipeReaderWriter >> isEmpty [
	closed ifTrue: [ ^ true ].
	^ self semaphoreForAccess critical: [ self collection isEmpty ]
]

{ #category : #accessing }
SWPipeReaderWriter >> next [
	"Answer the next object accessible by the receiver."

	self error: 'I should not be called.'
]

{ #category : #accessing }
SWPipeReaderWriter >> nextPut: anObject [
	"Insert the argument, anObject, as the next object accessible by the
	receiver. Answer anObject."

	self error: 'I should not be called.'
]

{ #category : #accessing }
SWPipeReaderWriter >> semaphoreForAccess [
	^ semaphoreForAccess ifNil: [ semaphoreForAccess := Semaphore forMutualExclusion ]
]

{ #category : #accessing }
SWPipeReaderWriter >> semaphoreForAccess: anObject [

	semaphoreForAccess := anObject
]

{ #category : #accessing }
SWPipeReaderWriter >> semaphoreForDone [
	^ self subclassResponsibility
]

{ #category : #accessing }
SWPipeReaderWriter >> semaphoreForDone: anObject [

	semaphoreForDone := anObject
]

{ #category : #accessing }
SWPipeReaderWriter >> semaphoreForWait [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWPipeReaderWriter >> semaphoreForWait: anObject [

	semaphoreForWait := anObject
]

{ #category : #waiting }
SWPipeReaderWriter >> wait [
	self semaphoreForWait wait.
	self semaphoreForDone initSignals.

]

{ #category : #waiting }
SWPipeReaderWriter >> waitDone [
	self semaphoreForDone
		wait;
		signal


]

{ #category : #waiting }
SWPipeReaderWriter >> waitReady [
	self semaphoreForWait
		wait;
		signal
]
