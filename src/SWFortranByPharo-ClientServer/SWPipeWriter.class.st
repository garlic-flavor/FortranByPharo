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
	semaphoreForAccess critical: [
		self collection add: anObject
	]
]

{ #category : #writing }
SWPipeWriter >> writeStream [
	^ self
]
