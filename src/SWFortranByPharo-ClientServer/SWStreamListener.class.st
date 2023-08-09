Class {
	#name : #SWStreamListener,
	#superclass : #SWAsyncStream,
	#instVars : [
		'callback'
	],
	#category : #'SWFortranByPharo-ClientServer-Shell'
}

{ #category : #accessing }
SWStreamListener >> callback [

	^ callback ifNil: [ callback := [ :txt | ] ]
]

{ #category : #accessing }
SWStreamListener >> callback: anObject [

	callback := anObject
]

{ #category : #'instance creation' }
SWStreamListener >> on: aStream [

	super on: aStream.
	process := [ [|c buf|
		[
			c := stream next.
			c isNil
		] whileTrue: [ self step ].
		buf := WriteStream on: String new.
		buf nextPut: c.
		[
			c := stream next.
			c ifNotNil: [
				buf nextPut: c.
				c ~= self class lineSep
			] ifNil: [ false ]
		] whileTrue.
		self callback value: buf contents
	] repeat	] fork.
	Processor yield.

]
