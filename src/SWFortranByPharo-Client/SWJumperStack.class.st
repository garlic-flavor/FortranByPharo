"
I represent jumper's stack in SWStackAnalyzer.
When 'jump' occur, the stack status become 'unpredictable' depends on its operand.
So when the step reaches to the destination of the jumper, the stack needs be rewind its status before the jumper.
"
Class {
	#name : #SWJumperStack,
	#superclass : #Object,
	#instVars : [
		'payload'
	],
	#category : #'SWFortranByPharo-Client-Analyzer'
}

{ #category : #testing }
SWJumperStack >> nextPeriodIs: pc [
	^ (0 < self payload size and: [ self payload top key = pc ])
]

{ #category : #accessing }
SWJumperStack >> payload [

	^ payload ifNil: [ payload := Stack new ]
]

{ #category : #accessing }
SWJumperStack >> payload: anObject [

	payload := anObject
]

{ #category : #removing }
SWJumperStack >> pop [
	^ self payload pop value.

]

{ #category : #accessing }
SWJumperStack >> pushAt: pc period: aPeriod size: size [
	(0 < self payload size and: [ self payload top key = pc ]) ifTrue: [
		(self payload)
			pop;
			push: (aPeriod -> size)
	] ifFalse: [
		self payload push: (aPeriod -> size)
	]
]
