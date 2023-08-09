Class {
	#name : #SWPipeReaderWritertoRemove,
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
	#category : #'SWFortranByPharo-ClientServer-toRemove'
}

{ #category : #'as yet unclassified' }
SWPipeReaderWritertoRemove class >> clearLineSep [
	lineSep := nil
]

{ #category : #accessing }
SWPipeReaderWritertoRemove class >> lineSep [
	^ lineSep ifNil: [ lineSep := Character cr ]
]

{ #category : #'instance creation' }
SWPipeReaderWritertoRemove class >> new [
	^ self basicNew
		initialize;
		yourself
]

{ #category : #testing }
SWPipeReaderWritertoRemove >> atEnd [
	"Answer whether the receiver can access any more objects."

	^ self isEmpty
]

{ #category : #'open/close' }
SWPipeReaderWritertoRemove >> close [
	closed ifTrue: [ ^ self ].
	self done.
	closed := true.

]

{ #category : #testing }
SWPipeReaderWritertoRemove >> closed [
	^ closed
]

{ #category : #accessing }
SWPipeReaderWritertoRemove >> collection [

	^ collection ifNil: [ collection := OrderedCollection new ]
]

{ #category : #accessing }
SWPipeReaderWritertoRemove >> collection: anObject [

	collection := anObject
]

{ #category : #accessing }
SWPipeReaderWritertoRemove >> contents [
	"Answer all of the contents of the receiver."
	closed ifTrue: [ ^ nil ].
	^ self semaphoreForAccess critical: [ self collection copy ]
]

{ #category : #running }
SWPipeReaderWritertoRemove >> done [
	self semaphoreForWait initSignals.
	self semaphoreForDone isSignaled ifTrue: [ ^ self ].
	self semaphoreForDone signal.


]

{ #category : #initialization }
SWPipeReaderWritertoRemove >> initialize [
	super initialize.
	closed := false
]

{ #category : #testing }
SWPipeReaderWritertoRemove >> isEmpty [
	closed ifTrue: [ ^ true ].
	^ self semaphoreForAccess critical: [ self collection isEmpty ]
]

{ #category : #accessing }
SWPipeReaderWritertoRemove >> next [
	"Answer the next object accessible by the receiver."

	self error: 'I should not be called.'
]

{ #category : #accessing }
SWPipeReaderWritertoRemove >> nextPut: anObject [
	"Insert the argument, anObject, as the next object accessible by the
	receiver. Answer anObject."

	self error: 'I should not be called.'
]

{ #category : #accessing }
SWPipeReaderWritertoRemove >> semaphoreForAccess [
	^ semaphoreForAccess ifNil: [ semaphoreForAccess := Semaphore forMutualExclusion ]
]

{ #category : #accessing }
SWPipeReaderWritertoRemove >> semaphoreForAccess: anObject [

	semaphoreForAccess := anObject
]

{ #category : #accessing }
SWPipeReaderWritertoRemove >> semaphoreForDone [
	^ self subclassResponsibility
]

{ #category : #accessing }
SWPipeReaderWritertoRemove >> semaphoreForDone: anObject [

	semaphoreForDone := anObject
]

{ #category : #accessing }
SWPipeReaderWritertoRemove >> semaphoreForWait [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWPipeReaderWritertoRemove >> semaphoreForWait: anObject [

	semaphoreForWait := anObject
]

{ #category : #waiting }
SWPipeReaderWritertoRemove >> wait [
	self semaphoreForWait wait.
	self semaphoreForDone initSignals.

]

{ #category : #waiting }
SWPipeReaderWritertoRemove >> waitDone [
	self semaphoreForDone
		wait;
		signal


]

{ #category : #waiting }
SWPipeReaderWritertoRemove >> waitReady [
	self semaphoreForWait
		wait;
		signal
]
