Class {
	#name : #SWStream,
	#superclass : #SharedQueue,
	#category : #'SWFortranByPharo-ClientServer-Tests'
}

{ #category : #streaming }
SWStream >> << anObject [
	self nextPut: anObject.
	Processor yield.

]

{ #category : #'bit manipulation' }
SWStream >> >> aBlock [
	[
		[
			aBlock value: self next
		] repeat
	] fork
]
