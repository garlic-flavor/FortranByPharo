"
I am stacked on SWJumperStack.
"
Class {
	#name : #SWJumperItem,
	#superclass : #Object,
	#instVars : [
		'startPC',
		'endPC',
		'stackSize',
		'stackTop'
	],
	#category : #'SWFortranByPharo-Analyzer-Slot'
}

{ #category : #accessing }
SWJumperItem >> endPC [

	^ endPC
]

{ #category : #accessing }
SWJumperItem >> endPC: anObject [

	endPC := anObject
]

{ #category : #accessing }
SWJumperItem >> stackSize [

	^ stackSize
]

{ #category : #accessing }
SWJumperItem >> stackSize: anObject [

	stackSize := anObject
]

{ #category : #accessing }
SWJumperItem >> stackTop [

	^ stackTop
]

{ #category : #accessing }
SWJumperItem >> stackTop: anObject [

	stackTop := anObject
]

{ #category : #accessing }
SWJumperItem >> startPC [

	^ startPC
]

{ #category : #accessing }
SWJumperItem >> startPC: anObject [

	startPC := anObject
]
