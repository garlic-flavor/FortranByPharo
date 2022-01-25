"
SWLog carries a stack trace information in SWLogger.
"
Class {
	#name : #SWLog,
	#superclass : #Object,
	#instVars : [
		'message',
		'context',
		'sender',
		'stack'
	],
	#category : #'SWFortranByPharo-Analyzer-Logger'
}

{ #category : #accessing }
SWLog >> context [

	^ context
]

{ #category : #accessing }
SWLog >> context: anObject [
	|s|
	context := anObject.
	s := anObject sender.
	[ s isNotNil ] whileTrue: [
		self sender add: s copy.
		s := s sender
	]
]

{ #category : #accessing }
SWLog >> message [

	^ message
]

{ #category : #accessing }
SWLog >> message: anObject [

	message := anObject
]

{ #category : #printing }
SWLog >> printOn: aStream [
	self putOn: aStream
]

{ #category : #streaming }
SWLog >> putOn: aStream [
	aStream << self message asString
]

{ #category : #accessing }
SWLog >> sender [

	^ sender ifNil: [ sender := OrderedCollection new ]
]

{ #category : #accessing }
SWLog >> sender: anObject [

	sender := anObject
]

{ #category : #accessing }
SWLog >> stack [

	^ stack
]

{ #category : #accessing }
SWLog >> stack: anObject [

	stack := anObject
]
