Class {
	#name : #SWPipe,
	#superclass : #Stream,
	#instVars : [
		'reader',
		'writer',
		'semaphoreForRead',
		'semaphoreForWrite',
		'semaphoreForAccess',
		'stdStream'
	],
	#category : #'SWFortranByPharo-ClientServer-Shell'
}

{ #category : #'instance creation' }
SWPipe class >> new [
	^ self basicNew
]

{ #category : #testing }
SWPipe >> atEnd [
	"Answer whether the receiver can access any more objects."

	^ self readStream atEnd
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
			collection: self stdStream;
			semaphoreForWait: semaphoreForRead;
			semaphoreForDone: semaphoreForWrite;
			semaphoreForAccess: semaphoreForAccess;
			yourself
	]
]

{ #category : #accessing }
SWPipe >> stdStream [

	^ stdStream ifNil: [ stdStream := OrderedCollection new ]
]

{ #category : #accessing }
SWPipe >> stdStream: anObject [

	stdStream := anObject
]

{ #category : #accessing }
SWPipe >> writeStream [

	^ writer ifNil: [
		writer := SWPipeWriter new
			collection: self stdStream;
			semaphoreForWait: semaphoreForWrite;
			semaphoreForDone: semaphoreForRead;
			semaphoreForAccess: semaphoreForAccess;
			yourself
	]
]
