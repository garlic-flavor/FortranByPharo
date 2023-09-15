"
This is a waiting styled asynchronous stream.
"
Class {
	#name : #SWWaitableStream,
	#superclass : #SWAsyncStream,
	#instVars : [
		'ready',
		'cur'
	],
	#category : #'SWFortranByPharo-ClientServer-Shell'
}

{ #category : #running }
SWWaitableStream >> done [
	ready initSignals
]

{ #category : #initialization }
SWWaitableStream >> initialize [
	super initialize.
	ready := Semaphore new
]

{ #category : #accessing }
SWWaitableStream >> next [
	^ cur ifNil: [
		super next
	] ifNotNil: [|c|
		c := cur.
		cur := nil.
		c
	]
]

{ #category : #'instance creation' }
SWWaitableStream >> on: aStream [
	super on: aStream.
	process := [ [
		ready isSignaled ifTrue: [
			self step
		] ifFalse: [
			self peek ifNil: [
				self step
			] ifNotNil: [
				ready signal
			]
		]
	] repeat ] fork.
	Processor yield.
	
]

{ #category : #accessing }
SWWaitableStream >> peek [
	^ cur ifNil: [ cur := super next ]
]

{ #category : #'as yet unclassified' }
SWWaitableStream >> readLn [
	^ String streamContents: [ :s |
		[ |c|
			c := self next.
			c ifNotNil:  [
				s nextPut: c.
				c ~= self class lineSep
			] ifNil: [ false ]
		] whileTrue.
	]
]

{ #category : #waiting }
SWWaitableStream >> wait [
	ready wait
]
