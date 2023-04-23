Class {
	#name : #SWPipeWriter,
	#superclass : #SWPipeReaderWriter,
	#category : #'SWFortranByPharo-ClientServer-Shell'
}

{ #category : #'stop conditions' }
SWPipeWriter >> cr [
	self nextPut: self class lineSep
]

{ #category : #accessing }
SWPipeWriter >> nextPut: anObject [
	semaphoreForAccess critical: [
		self collection add: anObject
	]
]
