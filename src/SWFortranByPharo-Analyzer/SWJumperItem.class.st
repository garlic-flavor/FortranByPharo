"
I am stacked on SWJumperStack.
"
Class {
	#name : #SWJumperItem,
	#superclass : #Object,
	#instVars : [
		'startPC',
		'endPC',
		'condition',
		'initialStack',
		'route1'
	],
	#category : #'SWFortranByPharo-Analyzer-Slot'
}

{ #category : #accessing }
SWJumperItem >> condition [

	^ condition
]

{ #category : #accessing }
SWJumperItem >> condition: anObject [

	condition := anObject
]

{ #category : #accessing }
SWJumperItem >> endPC [

	^ endPC
]

{ #category : #accessing }
SWJumperItem >> endPC: anObject [

	endPC := anObject
]

{ #category : #testing }
SWJumperItem >> hasRoute1 [
	^ route1 isNotNil
]

{ #category : #accessing }
SWJumperItem >> initialStack [

	^ initialStack
]

{ #category : #accessing }
SWJumperItem >> initialStack: anObject [

	initialStack := anObject
]

{ #category : #accessing }
SWJumperItem >> route1 [

	^ route1
]

{ #category : #accessing }
SWJumperItem >> route1: anObject [

	route1 := anObject
]

{ #category : #accessing }
SWJumperItem >> startPC [

	^ startPC
]

{ #category : #accessing }
SWJumperItem >> startPC: anObject [

	startPC := anObject
]
