Class {
	#name : #SWPipeReadertoRemove,
	#superclass : #SWPipeReaderWritertoRemove,
	#instVars : [
		'process'
	],
	#category : #'SWFortranByPharo-ClientServer-toRemove'
}

{ #category : #'bit manipulation' }
SWPipeReadertoRemove >> >> aBlock [
	process ifNotNil: [ process terminate ].
	process := [ [
		self wait.
		aBlock value: (String readFrom: self).
		self closed.
	] whileFalse ] fork.
]

{ #category : #'open/close' }
SWPipeReadertoRemove >> close [
	process ifNotNil: [
		process terminate.
		process := nil.
	].
	super close.
]

{ #category : #accessing }
SWPipeReadertoRemove >> next [
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
SWPipeReadertoRemove >> readStream [
	^ self
]

{ #category : #accessing }
SWPipeReadertoRemove >> semaphoreForDone [
	^ semaphoreForDone ifNil: [ semaphoreForDone := Semaphore forMutualExclusion ]
]

{ #category : #accessing }
SWPipeReadertoRemove >> semaphoreForWait [
	^ semaphoreForWait ifNil: [semaphoreForWait := Semaphore new ]
]

{ #category : #positioning }
SWPipeReadertoRemove >> skipTo: anObject [
	|pos|
	pos := collection indexOf: anObject.
	^ pos = 0 ifTrue: [ false ] ifFalse: [
		collection removeFirst: pos.
		true		
	]
]

{ #category : #writing }
SWPipeReadertoRemove >> writeStream [
	^ SWPipeWritertoRemove new
		collection: self collection;
		semaphoreForAccess: self semaphoreForAccess;
		semaphoreForWait: self semaphoreForDone;
		semaphoreForDone: self semaphoreForWait;
		yourself
]
