"
I represent jumper's stack in SWStackAnalyzer
"
Class {
	#name : #SWJumperStack,
	#superclass : #Object,
	#instVars : [
		'payload',
		'period'
	],
	#category : #'SWFortranByPharo-Client-Analyzer'
}

{ #category : #testing }
SWJumperStack >> nextPeriodIs: pc [
	^ (0 < self payload size and: [ self payload top = pc ])
]

{ #category : #accessing }
SWJumperStack >> payload [

	^ payload ifNil: [ payload := Stack new ]
]

{ #category : #accessing }
SWJumperStack >> payload: anObject [

	payload := anObject
]

{ #category : #accessing }
SWJumperStack >> period [

	^ period
]

{ #category : #accessing }
SWJumperStack >> period: anObject [

	period := anObject
]

{ #category : #removing }
SWJumperStack >> pop [
	|val|
	val := self payload pop value.
	self payload ifNotEmpty: [
		self period: self payload top
	] ifEmpty: [
		self period: nil
	].
	^ val
]

{ #category : #accessing }
SWJumperStack >> pushAt: pc period: aPeriod [
	self period: aPeriod.
	(0 < self payload size and: [ self payload top = pc ]) ifTrue: [
		(self payload)
			pop;
			push: aPeriod
	] ifFalse: [
		self payload push: aPeriod 
	]
]
