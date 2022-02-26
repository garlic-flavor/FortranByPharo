"
SWSender is a selector with its operands.
"
Class {
	#name : #SWMessageInfo,
	#superclass : #SWSenderInfo,
	#instVars : [
		'result'
	],
	#category : #'SWFortranByPharo-Analyzer-Analyzer'
}

{ #category : #'instance creation' }
SWMessageInfo class >> newFrom: anObject [
	anObject class = SWSenderInfo ifTrue: [
		^ self new
			method: anObject method;
			operands: anObject operands;
			yourself.
	].
	self error.
]

{ #category : #testing }
SWMessageInfo >> hasResult [
	^ result isNotNil
]

{ #category : #accessing }
SWMessageInfo >> messageInfo [
	^ self
]

{ #category : #accessing }
SWMessageInfo >> result [

	^ result ifNil: [ result := SWValue new ]
]

{ #category : #accessing }
SWMessageInfo >> result: anObject [

	result := anObject
]
