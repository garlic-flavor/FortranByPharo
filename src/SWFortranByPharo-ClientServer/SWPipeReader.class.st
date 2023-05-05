Class {
	#name : #SWPipeReader,
	#superclass : #SWPipeReaderWriter,
	#category : #'SWFortranByPharo-ClientServer-Shell'
}

{ #category : #'bit manipulation' }
SWPipeReader >> >> aBlock [
	[[
		self wait.
		aBlock value: (String streamContents: [:s | s << self upToEnd ]).
		self waitDone.
		self closed.
	] whileFalse ] fork
]

{ #category : #accessing }
SWPipeReader >> next [
	^ semaphoreForAccess critical: [
		self collection ifEmpty: [ nil ] ifNotEmpty: [|ret|
			ret := self collection removeFirst.
			self collection ifEmpty: [ self done ].
			ret
		]
	]
]
