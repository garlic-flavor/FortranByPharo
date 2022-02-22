"
SWSender is a selector with its operands.
"
Class {
	#name : #SWSender,
	#superclass : #Object,
	#instVars : [
		'method',
		'operands'
	],
	#category : #'SWFortranByPharo-Analyzer-Analyzer'
}

{ #category : #comparing }
SWSender >> = right [
	^ self method = right method and: [ self operands = right operands ]
]

{ #category : #comparing }
SWSender >> hash [
	^ (operands copyWith: method) hash
]

{ #category : #accessing }
SWSender >> method [

	^ method
]

{ #category : #accessing }
SWSender >> method: anObject [

	method := anObject
]

{ #category : #accessing }
SWSender >> operands [

	^ operands
]

{ #category : #accessing }
SWSender >> operands: anObject [

	operands := anObject
]

{ #category : #streaming }
SWSender >> printOn: aStream [
	self putOn: aStream
]

{ #category : #streaming }
SWSender >> putOn: aStream [
	method ifNil: [
		aStream << 'nil'
	] ifNotNil: [
		aStream << method selector
	]
]
