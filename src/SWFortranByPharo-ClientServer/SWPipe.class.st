Class {
	#name : #SWPipe,
	#superclass : #Object,
	#instVars : [
		'reader',
		'writer',
		'semaphoreForRead',
		'semaphoreForWrite',
		'semaphoreForAccess',
		'errReader',
		'errWriter',
		'semaphoreForErrorRead',
		'semaphoreForErrorAccess',
		'stdStream',
		'errStream'
	],
	#category : #'SWFortranByPharo-ClientServer-Shell'
}

{ #category : #accessing }
SWPipe >> errReader [

	^ errReader ifNil: [
		errReader := SWPipeReader new
			collection: self errStream;
			semaphoreForWait: semaphoreForErrorRead;
			semaphoreForAccess: semaphoreForAccess;
			yourself
	]
]

{ #category : #accessing }
SWPipe >> errStream [

	^ errStream ifNil: [ errStream := OrderedCollection new ]
]

{ #category : #accessing }
SWPipe >> errStream: anObject [

	errStream := anObject
]

{ #category : #accessing }
SWPipe >> errWriter [

	^ errWriter ifNil: [
		errWriter := SWPipeWriter new
			collection: self errStream;
			semaphoreForDone: semaphoreForErrorRead;
			semaphoreForAccess: semaphoreForErrorAccess;
			yourself
	]
]

{ #category : #initialization }
SWPipe >> initialize [
	super initialize.

	semaphoreForRead := Semaphore new.
	semaphoreForWrite := Semaphore forMutualExclusion.
	semaphoreForAccess := Semaphore forMutualExclusion.
	semaphoreForErrorRead := Semaphore new.
	semaphoreForErrorAccess := Semaphore forMutualExclusion.
	
]

{ #category : #accessing }
SWPipe >> reader [

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
SWPipe >> writer [

	^ writer ifNil: [
		writer := SWPipeWriter new
			collection: self stdStream;
			semaphoreForWait: semaphoreForWrite;
			semaphoreForDone: semaphoreForRead;
			semaphoreForAccess: semaphoreForAccess;
			yourself
	]
]
