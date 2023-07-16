Class {
	#name : #SWStd,
	#superclass : #Stream,
	#instVars : [
		'in',
		'out',
		'err',
		'pipes',
		'args',
		'readStream',
		'writeStream'
	],
	#category : #'SWFortranByPharo-ClientServer-Shell'
}

{ #category : #'instance creation' }
SWStd class >> new [
	^ self basicNew
		initialize;
		yourself
]

{ #category : #comparing }
SWStd >> < inputStream [

	self in: inputStream
]

{ #category : #comparing }
SWStd >> > outputStream [

	self out: outputStream
]

{ #category : #'bit manipulation' }
SWStd >> >> aBlock [

	^ self in >> aBlock
]

{ #category : #accessing }
SWStd >> args [

	^ args ifNil: [ args := OrderedCollection new ]
]

{ #category : #accessing }
SWStd >> args: anObject [

	args := anObject
]

{ #category : #testing }
SWStd >> atEnd [
	"Answer whether the receiver can access any more objects."

	^ self readStream atEnd
]

{ #category : #'open/close' }
SWStd >> close [

	self in close.
	self out close.
	self err close.
	self readStream close.
	self writeStream close.
	self closePipes.


]

{ #category : #'open/close' }
SWStd >> closePipes [

	pipes ifNotNil: [
		pipes do: [ :p | p close ].
		pipes := nil
	].

]

{ #category : #testing }
SWStd >> closed [

	^ self readStream closed and: [ self writeStream closed ]
]

{ #category : #accessing }
SWStd >> contents [
	"Answer all of the contents of the receiver."

	^ self readStream contents
]

{ #category : #running }
SWStd >> done [
	(self out respondsTo: #done) ifTrue: [
		self out done.
	]

]

{ #category : #accessing }
SWStd >> err [

	^ err ifNil: [ err := SWPipeWriter new ]
]

{ #category : #accessing }
SWStd >> err: aStream [

	err := aStream
]

{ #category : #accessing }
SWStd >> in [
	^ in ifNil: [ in := SWPipeReader new
		>> [ :txt | (self out) nextPutAll: txt; done ];
		yourself
	]
]

{ #category : #accessing }
SWStd >> in: aStream [

	in := aStream
]

{ #category : #running }
SWStd >> ln [
	(self out respondsTo: #ln) ifTrue: [
		self out ln
	] ifFalse: [
		self out nextPut: String cr
	]

]

{ #category : #'instance creation' }
SWStd >> newPipe [

	^ self pipes add: SWPipe new
]

{ #category : #accessing }
SWStd >> next [
	"Answer the next object accessible by the receiver."
	^ self readStream next
]

{ #category : #accessing }
SWStd >> nextPut: anObject [
	"Insert the argument, anObject, as the next object accessible by the
	receiver. Answer anObject."
	^ self writeStream nextPut: anObject
]

{ #category : #accessing }
SWStd >> out [

	^ out ifNil: [ out := SWPipeWriter new ]
]

{ #category : #accessing }
SWStd >> out: aStream [

	out := aStream
]

{ #category : #accessing }
SWStd >> pipes [

	^ pipes ifNil: [ pipes := OrderedCollection new ]
]

{ #category : #accessing }
SWStd >> pipes: anObject [

	pipes := anObject
]

{ #category : #accessing }
SWStd >> readStream [
	^ readStream ifNil: [ readStream := self out readStream ]

]

{ #category : #accessing }
SWStd >> readStream: aStream [
	readStream := aStream
]

{ #category : #writing }
SWStd >> writeStream [

	^ writeStream ifNil: [ writeStream := self in writeStream ]
]

{ #category : #accessing }
SWStd >> writeStream: aStream [
	writeStream := aStream
]
