Class {
	#name : #SWPipeWriter,
	#superclass : #SWPipeReaderWriter,
	#category : #'SWFortranByPharo-ClientServer-Shell'
}

{ #category : #'instance creation' }
SWPipeWriter >> ln [
	^ self
		nextPut: String cr;
		done;
		yourself
]

{ #category : #accessing }
SWPipeWriter >> nextPut: anObject [
	self semaphoreForAccess critical: [
		self collection add: anObject
	]
]

{ #category : #accessing }
SWPipeWriter >> readStream [
	^ SWPipeReader new
		collection: self collection;
		semaphoreForAccess: self semaphoreForAccess;
		semaphoreForWait: self semaphoreForDone;
		semaphoreForDone: self semaphoreForWait;
		yourself
]

{ #category : #accessing }
SWPipeWriter >> semaphoreForDone [
	^ semaphoreForDone ifNil: [ semaphoreForDone := Semaphore new ]
]

{ #category : #accessing }
SWPipeWriter >> semaphoreForWait [
	^ semaphoreForWait ifNil: [ semaphoreForWait := Semaphore forMutualExclusion ]
]

{ #category : #writing }
SWPipeWriter >> writeStream [
	^ self
]
