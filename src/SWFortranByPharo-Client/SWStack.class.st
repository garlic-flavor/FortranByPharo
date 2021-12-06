Class {
	#name : #SWStack,
	#superclass : #Object,
	#instVars : [
		'payload'
	],
	#category : #'SWFortranByPharo-Client-Analyzer'
}

{ #category : #'instance creation' }
SWStack class >> newFrom: arg1 [

	| tmp1 |
	tmp1 := self new.
	arg1 do: [ :arg2 | tmp1 push: arg2 ].
	^ tmp1
]

{ #category : #converting }
SWStack >> asArray [

	^ self payload asArray
]

{ #category : #accessing }
SWStack >> at: arg1 [

	^ self payload at: arg1 + 1 ifAbsent: [  ]
]

{ #category : #accessing }
SWStack >> atOffset: arg1 [

	^ self payload at: arg1 + 2 ifAbsent: [  ]
]

{ #category : #copying }
SWStack >> copyFrom: arg1 to: arg2 [

	^ self payload copyFrom: arg1 + 1 to: arg2 + 1
]

{ #category : #enumerating }
SWStack >> detect: arg1 ifNone: arg2 [

	^ self payload detect: arg1 ifNone: arg2
]

{ #category : #accessing }
SWStack >> payload [

	^ payload
		  ifNil: [ payload := OrderedCollection new ]
		  ifNotNil: [ payload ]
]

{ #category : #accessing }
SWStack >> payload: arg1 [

	payload := arg1
]

{ #category : #removing }
SWStack >> pop [

	^ self payload removeLast
]

{ #category : #affecting }
SWStack >> pop: arg1 [

	| tmp1 |
	tmp1 := OrderedCollection new.
	arg1 timesRepeat: [ tmp1 addFirst: self pop ].
	^ tmp1
]

{ #category : #adding }
SWStack >> push: arg1 [

	^ self payload addLast: arg1
]

{ #category : #'as yet unclassified' }
SWStack >> push: arg1 afterIndex: arg2 [

	^ self payload add: arg1 afterIndex: arg2 + 1
]

{ #category : #accessing }
SWStack >> size [

	^ self payload size
]

{ #category : #accessing }
SWStack >> top [

	^ self payload last
]
