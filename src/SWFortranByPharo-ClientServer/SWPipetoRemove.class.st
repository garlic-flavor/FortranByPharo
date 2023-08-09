"
Stream Layout

           ============== Data Flow ==============>

    +--------+        +------- SWPipe ----+         +----+
    |previous| = writeStream ======== readStream => |next|
    |  pipe  |        |    (same entity)  |         |pipe|
    +--------+        +-------------------+         +----+
"
Class {
	#name : #SWPipetoRemove,
	#superclass : #Stream,
	#instVars : [
		'reader',
		'writer',
		'semaphoreForRead',
		'semaphoreForWrite',
		'semaphoreForAccess',
		'collection'
	],
	#category : #'SWFortranByPharo-ClientServer-toRemove'
}

{ #category : #'instance creation' }
SWPipetoRemove class >> new [
	^ self basicNew
		initialize;
		yourself
]

{ #category : #'bit manipulation' }
SWPipetoRemove >> >> aBlock [
	self readStream >> aBlock

]

{ #category : #testing }
SWPipetoRemove >> atEnd [
	"Answer whether the receiver can access any more objects."

	^ self readStream atEnd
]

{ #category : #'open/close' }
SWPipetoRemove >> close [
	self closed ifTrue: [ ^ self ].
	semaphoreForAccess terminateProcess.
	semaphoreForWrite terminateProcess.
	semaphoreForRead terminateProcess.
	self readStream close.
	self writeStream close.

]

{ #category : #testing }
SWPipetoRemove >> closed [
	^ self readStream closed and: [ self writeStream closed ]
]

{ #category : #accessing }
SWPipetoRemove >> collection [

	^ collection ifNil: [ collection := OrderedCollection new ]
]

{ #category : #accessing }
SWPipetoRemove >> collection: anObject [

	collection := anObject
]

{ #category : #accessing }
SWPipetoRemove >> contents [
	"Answer all of the contents of the receiver."

	^ self readStream contents
]

{ #category : #initialization }
SWPipetoRemove >> initialize [
	super initialize.

	semaphoreForRead := Semaphore new.
	semaphoreForWrite := Semaphore forMutualExclusion.
	semaphoreForAccess := Semaphore forMutualExclusion.
	
]

{ #category : #accessing }
SWPipetoRemove >> next [
	"Answer the next object accessible by the receiver."

	^ self readStream next
]

{ #category : #accessing }
SWPipetoRemove >> nextPut: anObject [
	"Insert the argument, anObject, as the next object accessible by the
	receiver. Answer anObject."

	self writeStream nextPut: anObject
]

{ #category : #accessing }
SWPipetoRemove >> readStream [

	^ reader ifNil: [
		reader := SWPipeReadertoRemove new
			collection: self collection;
			semaphoreForWait: semaphoreForRead;
			semaphoreForDone: semaphoreForWrite;
			semaphoreForAccess: semaphoreForAccess;
			yourself
	]
]

{ #category : #accessing }
SWPipetoRemove >> writeStream [

	^ writer ifNil: [
		writer := SWPipeWritertoRemove new
			collection: self collection;
			semaphoreForWait: semaphoreForWrite;
			semaphoreForDone: semaphoreForRead;
			semaphoreForAccess: semaphoreForAccess;
			yourself
	]
]
