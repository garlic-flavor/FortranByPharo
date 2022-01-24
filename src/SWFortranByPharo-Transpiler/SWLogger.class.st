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
	#category : #'SWFortranByPharo-Transpiler-Common'
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

{ #category : #private }
SWLogger >> getDepthOf: aContext [
	self error; flag: #toRemove.
	aContext ifNil: [ ^ 0	].
	(self selector value: aContext) ifTrue: [ 
		^ 1 + (self getDepthOf: aContext sender)
	] ifFalse: [
		^ self getDepthOf: aContext sender
	]
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
	self flag: #toRemove.	
"
	|depth|
	depth := self getDepthOf: aContext.
	Transcript << ('  ' repeat: depth); << aContext asString; << '> '; << msg value; cr; flush
"
]

{ #category : #accessing }
SWLogger >> payload [

	^ payload ifNil: [ payload := OrderedCollection new ]
]

{ #category : #accessing }
SWLogger >> payload: anObject [

	payload := anObject
]

{ #category : #accessing }
SWLogger >> selector [
	self error; flag: #toRemove.
	^ selector ifNil: [
		selector := [ :aContext |
			aContext receiver className beginsWith: 'SW'
		]
	]
]

{ #category : #accessing }
SWLogger >> selector: aSelectorBlock [
	self error; flag: #toRemove.
	selector := aSelectorBlock 
]
