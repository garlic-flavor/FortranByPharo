"
log like stack tracing.
"
Class {
	#name : #SWLogger,
	#superclass : #Object,
	#instVars : [
		'enabled',
		'selector'
	],
	#category : #'SWFortranByPharo-Client'
}

{ #category : #accessing }
SWLogger >> enabled [

	^ enabled ifNil: [ enabled := false ]
]

{ #category : #accessing }
SWLogger >> enabled: anObject [

	enabled := anObject
]

{ #category : #'as yet unclassified' }
SWLogger >> getDepthOf: aContext [
	aContext ifNil: [ ^ 0	].
	(self selector value: aContext) ifTrue: [ 
		^ 1 + (self getDepthOf: aContext sender)
	] ifFalse: [
		^ self getDepthOf: aContext sender
	]
]

{ #category : #accessing }
SWLogger >> log [
	self log: '' withContext: thisContext sender.
]

{ #category : #'instance creation' }
SWLogger >> log: msg [
	self log: msg withContext: thisContext sender
]

{ #category : #'instance creation' }
SWLogger >> log: msg withContext: aContext [
	|depth|
	self enabled ifFalse: [ ^ self ].
	depth := self getDepthOf: aContext.
	Transcript << ('  ' repeat: depth); << aContext asString; << '> '; << msg value; cr; flush

]

{ #category : #accessing }
SWLogger >> selector [
	^ selector ifNil: [
		selector := [ :aContext |
			aContext receiver className beginsWith: 'SW'
		]
	]
]

{ #category : #accessing }
SWLogger >> selector: aSelectorBlock [
	selector := aSelectorBlock 
]
