"
operands and its result of a message.
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

{ #category : #testing }
SWMessageInfo >> isSubroutine [
	^ self result value = self method methodClass
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
