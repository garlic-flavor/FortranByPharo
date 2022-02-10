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
	#category : #'SWFortranByPharo-Analyzer-Slot'
}

{ #category : #testing }
SWJumperStack >> nextPeriodIs: pc [
	^ (self payload isNotEmpty and: [ self payload top endPC = pc ])
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
	^ self payload pop.

]

{ #category : #adding }
SWJumperStack >> push: aJumperItem [
	self payload push: aJumperItem
]

{ #category : #modifying }
SWJumperStack >> update: aPeriod [
	self payload push: ((self pop)
			endPC: aPeriod;
			yourself)

]
