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
