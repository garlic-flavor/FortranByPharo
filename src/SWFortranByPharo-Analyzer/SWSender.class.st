"
SWSender is a selector with its operands.
"
Class {
	#name : #SWSender,
	#superclass : #Object,
	#instVars : [
		'selector',
		'operands'
	],
	#category : #'SWFortranByPharo-Analyzer-Analyzer'
}

{ #category : #comparing }
SWSender >> = right [
	^ self selector = right selector and: [ self operands = right operands ]
]

{ #category : #comparing }
SWSender >> hash [
	^ (operands copyWith: selector) hash
]

{ #category : #accessing }
SWSender >> operands [

	^ operands
]

{ #category : #accessing }
SWSender >> operands: anObject [

	operands := anObject
]

{ #category : #accessing }
SWSender >> selector [

	^ selector
]

{ #category : #accessing }
SWSender >> selector: anObject [

	selector := anObject

]
