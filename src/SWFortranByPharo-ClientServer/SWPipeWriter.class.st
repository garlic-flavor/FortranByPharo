Class {
	#name : #SWPipeWriter,
	#superclass : #SWPipeReaderWriter,
	#category : #'SWFortranByPharo-ClientServer-Shell'
}

{ #category : #'instance creation' }
SWPipeWriter >> ln [
	self nextPut: self class lineSep

]

{ #category : #accessing }
SWPipeWriter >> nextPut: anObject [
	anObject isCharacter ifFalse: [
		^ self nextPutAll: anObject asString
	].
	anObject = self class lineSep ifTrue: [
		^ self done; waitReady
	].
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
