"
SWSender is a parent of SWSenderTranspiler.
"
Class {
	#name : #SWSender,
	#superclass : #Object,
	#instVars : [
		'selector',
		'return',
		'operands',
		'node'
	],
	#category : #'SWFortranByPharo-Analyzer-Analyzer'
}

{ #category : #comparing }
SWSender >> = right [
	self selector = right selector ifFalse: [ ^ false ].
	^ self operands = right operands
]

{ #category : #comparing }
SWSender >> hash [
	"The hash depends on this method and its operands."
	|args buf|
	args := self operands.
	buf := OrderedCollection new: self operands size + 1.
	buf add: self selector hash.
	buf addAll: (self operands collect: [ :one |
		one hash
	]).
	^ buf hash
]

{ #category : #accessing }
SWSender >> node [

	^ node
]

{ #category : #accessing }
SWSender >> node: anObject [

	node := anObject
]

{ #category : #accessing }
SWSender >> operands [

	^ operands
]

{ #category : #accessing }
SWSender >> operands: anObject [

	operands := anObject
]

{ #category : #printing }
SWSender >> printOn: aStream [
	self putOn: aStream
]

{ #category : #streaming }
SWSender >> putOn: aStream [
	aStream
		<< self selector;
		<< self operands
]

{ #category : #accessing }
SWSender >> return [

	^ return ifNil: [ return := SWVariableTypeInfo new ]
]

{ #category : #accessing }
SWSender >> return: anObject [

	return := anObject
]

{ #category : #accessing }
SWSender >> selector [

	^ selector
]

{ #category : #accessing }
SWSender >> selector: anObject [

	selector := anObject
]

{ #category : #accessing }
SWSender >> specifyReturnTypeAs: aType [
	self return << aType
]
