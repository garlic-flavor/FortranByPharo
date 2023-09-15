Class {
	#name : #SWFProgram,
	#superclass : #Object,
	#instVars : [
		'io'
	],
	#category : #'SWFortranByPharo-FFCaller'
}

{ #category : #initialization }
SWFProgram class >> decode_self: cdt [
	cdt declareSlot: #io as: SWIO.

]

{ #category : #accessing }
SWFProgram >> io: anObject [
	io := anObject
]

{ #category : #accessing }
SWFProgram >> main [
	^ self subclassResponsibility
]
