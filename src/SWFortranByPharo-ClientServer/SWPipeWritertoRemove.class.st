Class {
	#name : #SWPipeWritertoRemove,
	#superclass : #SWPipeReaderWritertoRemove,
	#category : #'SWFortranByPharo-ClientServer-toRemove'
}

{ #category : #'instance creation' }
SWPipeWritertoRemove >> ln [
	self nextPut: self class lineSep

]

{ #category : #accessing }
SWPipeWritertoRemove >> nextPut: anObject [
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
SWPipeWritertoRemove >> readStream [
	^ SWPipeReadertoRemove new
		collection: self collection;
		semaphoreForAccess: self semaphoreForAccess;
		semaphoreForWait: self semaphoreForDone;
		semaphoreForDone: self semaphoreForWait;
		yourself
]

{ #category : #accessing }
SWPipeWritertoRemove >> semaphoreForDone [
	^ semaphoreForDone ifNil: [ semaphoreForDone := Semaphore new ]
]

{ #category : #accessing }
SWPipeWritertoRemove >> semaphoreForWait [
	^ semaphoreForWait ifNil: [ semaphoreForWait := Semaphore forMutualExclusion ]
]

{ #category : #writing }
SWPipeWritertoRemove >> writeStream [
	^ self
]
