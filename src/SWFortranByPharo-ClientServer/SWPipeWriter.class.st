Class {
	#name : #SWPipeWriter,
	#superclass : #SWPipeReaderWriter,
	#category : #'SWFortranByPharo-ClientServer-Shell'
}

{ #category : #accessing }
SWPipeWriter >> nextPut: anObject [
	semaphoreForAccess critical: [
		self collection add: anObject
	]
]

{ #category : #writing }
SWPipeWriter >> writeStream [
	^ self
]
