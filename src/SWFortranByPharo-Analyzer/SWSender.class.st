"
SWSender is a parent of SWSenderTranspiler.
"
Class {
	#name : #SWSender,
	#superclass : #Object,
	#instVars : [
		'selector',
		'return',
		'receiver',
		'arguments',
		'node',
		'method'
	],
	#category : #'SWFortranByPharo-Analyzer-Analyzer'
}

{ #category : #comparing }
SWSender >> = right [
	self selector = right selector ifFalse: [ ^ false ].
	self receiver = right receiver ifFalse: [ ^ false ].
	^ self arguments = right arguments
]

{ #category : #accessing }
SWSender >> arguments [

	^ arguments
]

{ #category : #accessing }
SWSender >> arguments: anObject [

	arguments := anObject
]

{ #category : #comparing }
SWSender >> hash [
	"The hash depends on this method and its operands."
	|args buf|
	args := self arguments.
	buf := OrderedCollection new: args size + 2.
	buf add: self selector.
	buf add: self receiver.
	buf addAll: args.
	^ buf hash
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
SWSender >> node [

	^ node
]

{ #category : #accessing }
SWSender >> node: anObject [

	node := anObject
]

{ #category : #printing }
SWSender >> printOn: aStream [
	self putOn: aStream
]

{ #category : #streaming }
SWSender >> putOn: aStream [
	aStream
		<< self selector;
		<< self arguments
]

{ #category : #accessing }
SWSender >> receiver [

	^ receiver
]

{ #category : #accessing }
SWSender >> receiver: anObject [

	receiver := anObject
]

{ #category : #accessing }
SWSender >> return [

	^ return
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
	return := SWVariableTypeInfo new: aType
]
