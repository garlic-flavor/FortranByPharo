Class {
	#name : #SWPipeReaderWriter,
	#superclass : #Stream,
	#instVars : [
		'collection',
		'semaphoreForWait',
		'semaphoreForDone',
		'semaphoreForAccess'
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
]

{ #category : #testing }
SWPipeReaderWriter >> atEnd [
	"Answer whether the receiver can access any more objects."

	^ self isEmpty
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

	^ self collection copy
]

{ #category : #running }
SWPipeReaderWriter >> done [
	semaphoreForDone ifNotNil: [
		semaphoreForDone signal
	].
	semaphoreForWait ifNotNil: [
		semaphoreForWait initSignals
	]
]

{ #category : #testing }
SWPipeReaderWriter >> isEmpty [
	^ semaphoreForAccess critical: [ self collection isEmpty ]
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
SWPipeReaderWriter >> semaphoreForAccess: anObject [

	semaphoreForAccess := anObject
]

{ #category : #accessing }
SWPipeReaderWriter >> semaphoreForDone: anObject [

	semaphoreForDone := anObject
]

{ #category : #accessing }
SWPipeReaderWriter >> semaphoreForWait: anObject [

	semaphoreForWait := anObject
]

{ #category : #waiting }
SWPipeReaderWriter >> wait [
	semaphoreForWait ifNotNil: [
		semaphoreForWait wait
	].
	semaphoreForDone ifNotNil: [
		semaphoreForDone initSignals
	]
]
