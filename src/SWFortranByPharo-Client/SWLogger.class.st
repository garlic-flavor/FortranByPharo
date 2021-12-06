Class {
	#name : #SWLogger,
	#superclass : #Object,
	#instVars : [
		'enabled',
		'selector'
	],
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #accessing }
SWLogger >> enabled [

	^ enabled ifNil: [ enabled := false ] ifNotNil: [ enabled ]
]

{ #category : #accessing }
SWLogger >> enabled: arg1 [

	enabled := arg1
]

{ #category : #private }
SWLogger >> getDepthOf: arg1 [

	arg1 ifNil: [ ^ 0 ].
	(self selector value: arg1) ifTrue: [ 
		^ 1 + (self getDepthOf: arg1 sender) ].
	^ self getDepthOf: arg1 sender
]

{ #category : #public }
SWLogger >> log [

	self log: '' withContext: thisContext sender
]

{ #category : #public }
SWLogger >> log: arg1 [

	self log: arg1 withContext: thisContext sender
]

{ #category : #private }
SWLogger >> log: arg1 withContext: arg2 [

	| tmp1 |
	self enabled ifFalse: [ ^ self ].
	tmp1 := self getDepthOf: arg2.
	Transcript
		<< ('  ' repeat: tmp1);
		<< arg2 asString;
		<< '> ';
		<< arg1 value;
		cr;
		flush
]

{ #category : #accessing }
SWLogger >> selector [

	^ selector
		  ifNil: [ 
		  selector := [ :arg1 | arg1 receiver className beginsWith: 'SW' ] ]
		  ifNotNil: [ selector ]
]

{ #category : #accessing }
SWLogger >> selector: arg1 [

	selector := arg1
]
