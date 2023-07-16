Class {
	#name : #SWPipeReader,
	#superclass : #SWPipeReaderWriter,
	#category : #'SWFortranByPharo-ClientServer-Shell'
}

{ #category : #'bit manipulation' }
SWPipeReader >> >> aBlock [
	[ [
		self wait.
		aBlock value: (String streamContents: [:s | s << self upToEnd ]).
		self closed.
	] whileFalse ] fork.
]

{ #category : #accessing }
SWPipeReader >> next [
	self closed ifTrue: [ ^ nil ].
	^ self semaphoreForAccess critical: [
		self collection ifEmpty: [
			self done.
			nil
		] ifNotEmpty: [|ret|
			ret := self collection removeFirst.
			self collection ifEmpty: [ self done ].
			ret
		]
	]
]

{ #category : #accessing }
SWPipeReader >> readStream [
	^ self
]

{ #category : #accessing }
SWPipeReader >> semaphoreForDone [
	^ semaphoreForDone ifNil: [ semaphoreForDone := Semaphore forMutualExclusion ]
]

{ #category : #accessing }
SWPipeReader >> semaphoreForWait [
	^ semaphoreForWait ifNil: [semaphoreForWait := Semaphore new ]
]

{ #category : #positioning }
SWPipeReader >> skipTo: anObject [
	|pos|
	pos := collection indexOf: anObject.
	^ pos = 0 ifTrue: [ false ] ifFalse: [
		collection removeFirst: pos.
		true		
	]
]

{ #category : #writing }
SWPipeReader >> writeStream [
	^ SWPipeWriter new
		collection: self collection;
		semaphoreForAccess: self semaphoreForAccess;
		semaphoreForWait: self semaphoreForDone;
		semaphoreForDone: self semaphoreForWait;
		yourself
]
