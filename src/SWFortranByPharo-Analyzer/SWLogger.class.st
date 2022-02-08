"
I am a logger class for SWTranspiler and its inherited classes.
I display logs to Transcript window while a transpiling process.
My main interface is SWLogger>>#log: method.

"
Class {
	#name : #SWLogger,
	#superclass : #Object,
	#instVars : [
		'enabled',
		'payload'
	],
	#category : #'SWFortranByPharo-Analyzer-Logger'
}

{ #category : #generation }
SWLogger >> dump [
	self payload inspect
]

{ #category : #accessing }
SWLogger >> enabled [

	^ enabled ifNil: [ enabled := false ]
]

{ #category : #accessing }
SWLogger >> enabled: anObject [

	enabled := anObject
]

{ #category : #public }
SWLogger >> log [
	self log: '' withContext: thisContext sender.
]

{ #category : #public }
SWLogger >> log: msg [
	self log: msg withContext: thisContext sender
]

{ #category : #private }
SWLogger >> log: msg withContext: aContext [
	self enabled ifFalse: [ ^ self ].
	self payload add: (SWLog new
		message: msg value;
		context: aContext copy;
		yourself).

]

{ #category : #public }
SWLogger >> log: msg withStack: aStack [
	self enabled ifFalse: [ ^ self ].
	self payload add: (SWLog new
		message: msg value;
		stack: aStack copy;
		context: thisContext sender copy;
		yourself).

]

{ #category : #accessing }
SWLogger >> payload [

	^ payload ifNil: [ payload := OrderedCollection new ]
]

{ #category : #accessing }
SWLogger >> payload: anObject [

	payload := anObject
]
