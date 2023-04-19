Class {
	#name : #SWStream,
	#superclass : #SharedQueue,
	#category : #'SWFortranByPharo-ClientServer-Shell'
}

{ #category : #'stop conditions' }
SWStream >> cr [
	^ self nextPut: Character cr
]

{ #category : #'as yet unclassified' }
SWStream >> readLine [
	| elements |
	elements := OrderedCollection new.
	[ self atEnd ] whileFalse: [|c|
		c := self next.
		(c asInteger = Character cr asInteger) ifTrue: [ ^ String newFrom: elements ].
		elements add: c.
	].
	^ String newFrom: elements
]

{ #category : #'as yet unclassified' }
SWStream >> waitDone [
	^ [
		monitor critical: [ items isEmpty ]
	] whileFalse: [ Processor yield ]
]
