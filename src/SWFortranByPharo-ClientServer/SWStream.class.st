Class {
	#name : #SWStream,
	#superclass : #SharedQueue,
	#category : #'SWFortranByPharo-ClientServer-Shell'
}

{ #category : #'stop conditions' }
SWStream >> cr [
	^ self nextPut: Character cr
]

{ #category : #enumerating }
SWStream >> eachLine: aBlock [
	[|l|
		(self closed or: [ self atEnd ]) ifTrue: [ ^ self ].
		l := self readLine.
		(l isNotEmpty or: [ self atEnd not ]) ifTrue: [
			(aBlock value: l) ifNil: [ ^ nil ]
		].
	] repeat
]

{ #category : #enumerating }
SWStream >> onEachLineDo: aBlock [
	^ [
		[
			self waitFilled.
			(self eachLine: aBlock) isNotNil
		] whileTrue
	] fork
]

{ #category : #'as yet unclassified' }
SWStream >> readLine [
	| elements |
	elements := OrderedCollection new.
	[|c|
		c := self next.
		(c asInteger = Character cr asInteger) ifTrue: [ ^ String newFrom: elements ].
		elements add: c.
		self atEnd
	] whileFalse.
	^ String newFrom: elements
]

{ #category : #'as yet unclassified' }
SWStream >> waitDone [
	[
		monitor critical: [ items isEmpty ]
	] whileFalse: [ (Delay forMilliseconds: 10) wait ]

]

{ #category : #'as yet unclassified' }
SWStream >> waitFilled [
	monitor critical: [
		monitor waitWhile: [ items isEmpty ].
	]
]
