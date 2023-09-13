Class {
	#name : #SWAsyncStream,
	#superclass : #Stream,
	#instVars : [
		'stream',
		'process',
		'delay'
	],
	#category : #'SWFortranByPharo-ClientServer-Shell'
}

{ #category : #accessing }
SWAsyncStream class >> lineSep [
	^ Character lf
]

{ #category : #'instance creation' }
SWAsyncStream class >> newOn: aStream [
	^ self basicNew
		initialize;
		on: aStream;
		yourself
]

{ #category : #'instance creation' }
SWAsyncStream class >> newOnPipe [
	^ self newOn: SWShell makeNonBlockingPipe

]

{ #category : #testing }
SWAsyncStream >> atEnd [
	"Answer whether the receiver can access any more objects."

	^ stream atEnd
]

{ #category : #'open/close' }
SWAsyncStream >> close [
	process ifNotNil: [
		process terminate.
		process := nil
	].
	stream ifNotNil: [
		stream close.
		stream := nil.
	].
	super close
]

{ #category : #closing }
SWAsyncStream >> closeReader [
	^ self stream closeReader
]

{ #category : #closing }
SWAsyncStream >> closeWriter [
	^ self stream closeWriter
]

{ #category : #accessing }
SWAsyncStream >> contents [
	"Answer all of the contents of the receiver."

	^ stream contents
]

{ #category : #accessing }
SWAsyncStream >> delay [

	^ delay ifNil: [ delay := 300 ]
]

{ #category : #accessing }
SWAsyncStream >> delay: anObject [

	delay := anObject
]

{ #category : #flushing }
SWAsyncStream >> flush [
	^ stream flush
]

{ #category : #'instance creation' }
SWAsyncStream >> ln [
	^ stream
		nextPut: self class lineSep;
		flush
]

{ #category : #accessing }
SWAsyncStream >> next [
	"Answer the next object accessible by the receiver."

	^ stream next
]

{ #category : #accessing }
SWAsyncStream >> nextPut: anObject [
	"Insert the argument, anObject, as the next object accessible by the
	receiver. Answer anObject."

	^ stream nextPut: anObject
]

{ #category : #'instance creation' }
SWAsyncStream >> on: aStream [
	self close.
	stream := aStream
]

{ #category : #testing }
SWAsyncStream >> ossIsPipe [
	^ self stream ossIsPipe
]

{ #category : #options }
SWAsyncStream >> reader [
	^ self stream reader
]

{ #category : #positioning }
SWAsyncStream >> skipTo: aChar [
	^ self stream skipTo: aChar
]

{ #category : #stepping }
SWAsyncStream >> step [
	(Delay forMilliseconds: self delay) wait
]

{ #category : #accessing }
SWAsyncStream >> stream [

	^ stream
]

{ #category : #accessing }
SWAsyncStream >> writer [
	^ self stream writer
]
