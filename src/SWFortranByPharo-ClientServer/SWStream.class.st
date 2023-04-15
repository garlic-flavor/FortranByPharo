Class {
	#name : #SWStream,
	#superclass : #SharedQueue,
	#category : #'SWFortranByPharo-ClientServer-Shell'
}

{ #category : #streaming }
SWStream >> << anObject [
	self nextPut: anObject.

]

{ #category : #'bit manipulation' }
SWStream >> >> aBlock [
	[
		[
			aBlock value: self next
		] repeat
	] fork
]

{ #category : #accessing }
SWStream >> nextPut: anObject [
	super nextPut: anObject.
	Processor yield.

]
