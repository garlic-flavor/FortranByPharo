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
SWJumperStack >> nextPeriodIs: arg1 [

	^ 0 < self payload size and: [ self payload top = arg1 ]
]

{ #category : #accessing }
SWJumperStack >> payload [

	^ payload ifNil: [ payload := Stack new ] ifNotNil: [ payload ]
]

{ #category : #accessing }
SWJumperStack >> payload: arg1 [

	payload := arg1
]

{ #category : #accessing }
SWJumperStack >> period [

	^ period
]

{ #category : #accessing }
SWJumperStack >> period: arg1 [

	period := arg1
]

{ #category : #removing }
SWJumperStack >> pop [

	| tmp1 |
	tmp1 := self payload pop value.
	self payload
		ifNotEmpty: [ self period: self payload top ]
		ifEmpty: [ self period: nil ].
	^ tmp1
]

{ #category : #accessing }
SWJumperStack >> pushAt: arg1 period: arg2 [

	self period: arg2.
	(0 < self payload size and: [ self payload top = arg1 ])
		ifTrue: [ 
			| tmp2 |
			tmp2 := self payload.
			tmp2
				pop;
				push: arg2 ]
		ifFalse: [ self payload push: arg2 ]
]
