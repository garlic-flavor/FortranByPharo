Class {
	#name : #SWTerminalMorphReader,
	#superclass : #SWTerminalMorphReaderWriter,
	#instVars : [
		'line'
	],
	#category : #'SWFortranByPharo-ClientServer-Shell'
}

{ #category : #testing }
SWTerminalMorphReader >> atEnd [
	^ line isEmptyOrNil
]

{ #category : #accessing }
SWTerminalMorphReader >> contents [
	^ line
]

{ #category : #'as yet unclassified' }
SWTerminalMorphReader >> fillLine [
	line := self morph getText asString.
	self morph setText: ''
]

{ #category : #accessing }
SWTerminalMorphReader >> next [
	^ self atEnd ifTrue: [ nil ] ifFalse: [ line removeFirst ]
]
