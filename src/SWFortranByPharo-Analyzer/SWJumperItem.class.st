"
I am stacked on SWJumperStack.
"
Class {
	#name : #SWJumperItem,
	#superclass : #Object,
	#instVars : [
		'startPC',
		'endPC'
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
SWJumperItem >> startPC [

	^ startPC
]

{ #category : #accessing }
SWJumperItem >> startPC: anObject [

	startPC := anObject
]
