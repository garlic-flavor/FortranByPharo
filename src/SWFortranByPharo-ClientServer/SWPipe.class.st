Class {
	#name : #SWPipe,
	#superclass : #Stream,
	#instVars : [
		'reader',
		'writer',
		'semaphoreForRead',
		'semaphoreForWrite',
		'semaphoreForAccess',
		'collection'
	],
	#category : #'SWFortranByPharo-ClientServer-Shell'
}

{ #category : #'instance creation' }
SWPipe class >> new [
	^ self basicNew
		initialize;
		yourself
]

{ #category : #'bit manipulation' }
SWPipe >> >> aBlock [
	self readStream >> aBlock

]

{ #category : #testing }
SWPipe >> atEnd [
	"Answer whether the receiver can access any more objects."

	^ self readStream atEnd
]

{ #category : #'open/close' }
SWPipe >> close [
	self closed ifTrue: [ ^ self ].
	semaphoreForAccess terminateProcess.
	semaphoreForWrite terminateProcess.
	semaphoreForRead terminateProcess.
	self readStream close.
	self writeStream close.

]

{ #category : #testing }
SWPipe >> closed [
	^ self readStream closed and: [ self writeStream closed ]
]

{ #category : #accessing }
SWPipe >> collection [

	^ collection ifNil: [ collection := OrderedCollection new ]
]

{ #category : #accessing }
SWPipe >> collection: anObject [

	collection := anObject
]

{ #category : #accessing }
SWPipe >> contents [
	"Answer all of the contents of the receiver."

	^ self readStream contents
]

{ #category : #initialization }
SWPipe >> initialize [
	super initialize.

	semaphoreForRead := Semaphore new.
	semaphoreForWrite := Semaphore forMutualExclusion.
	semaphoreForAccess := Semaphore forMutualExclusion.
	
]

{ #category : #accessing }
SWPipe >> next [
	"Answer the next object accessible by the receiver."

	^ self readStream next
]

{ #category : #accessing }
SWPipe >> nextPut: anObject [
	"Insert the argument, anObject, as the next object accessible by the
	receiver. Answer anObject."

	self writeStream nextPut: anObject
]

{ #category : #accessing }
SWPipe >> readStream [

	^ reader ifNil: [
		reader := SWPipeReader new
			collection: self collection;
			semaphoreForWait: semaphoreForRead;
			semaphoreForDone: semaphoreForWrite;
			semaphoreForAccess: semaphoreForAccess;
			yourself
	]
]

{ #category : #accessing }
SWPipe >> writeStream [

	^ writer ifNil: [
		writer := SWPipeWriter new
			collection: self collection;
			semaphoreForWait: semaphoreForWrite;
			semaphoreForDone: semaphoreForRead;
			semaphoreForAccess: semaphoreForAccess;
			yourself
	]
]
