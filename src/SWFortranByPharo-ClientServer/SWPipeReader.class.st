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

{ #category : #accessing }
SWPipeReader >> nextLine [
	|buf|
	buf := OrderedCollection new.
	[|c|
		self isEmpty ifTrue: [ ^ String newFromArray: buf ].
		c := self next.
		c asInteger = self class lineSep asInteger ifTrue: [ ^ String newFromArray: buf ].
		buf add: c
	] repeat

]
