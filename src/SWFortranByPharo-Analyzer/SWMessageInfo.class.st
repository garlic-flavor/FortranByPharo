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
