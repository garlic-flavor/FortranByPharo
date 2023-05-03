Class {
	#name : #SWPipeReader,
	#superclass : #SWPipeReaderWriter,
	#category : #'SWFortranByPharo-ClientServer-Shell'
}

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
