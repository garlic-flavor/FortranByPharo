"
SWSender is a parent of SWSenderTranspiler.
"
Class {
	#name : #SWSenderOld,
	#superclass : #Object,
	#instVars : [
		'selector',
		'return',
		'receiver',
		'arguments',
		'node',
		'method'
	],
	#category : #'SWFortranByPharo-Analyzer-Olds'
}

{ #category : #comparing }
SWSenderOld >> = right [
	self selector = right selector ifFalse: [ ^ false ].
	self receiver = right receiver ifFalse: [ ^ false ].
	^ self arguments = right arguments
]

{ #category : #accessing }
SWSenderOld >> arguments [

	^ arguments
]

{ #category : #accessing }
SWSenderOld >> arguments: anObject [

	arguments := anObject
]

{ #category : #comparing }
SWSenderOld >> hash [
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
SWSenderOld >> method [

	^ method
]

{ #category : #accessing }
SWSenderOld >> method: anObject [

	method := anObject
]

{ #category : #accessing }
SWSenderOld >> node [

	^ node
]

{ #category : #accessing }
SWSenderOld >> node: anObject [

	node := anObject
]

{ #category : #printing }
SWSenderOld >> printOn: aStream [
	self putOn: aStream
]

{ #category : #streaming }
SWSenderOld >> putOn: aStream [
	aStream
		<< self selector;
		<< self arguments
]

{ #category : #accessing }
SWSenderOld >> receiver [

	^ receiver
]

{ #category : #accessing }
SWSenderOld >> receiver: anObject [

	receiver := anObject
]

{ #category : #accessing }
SWSenderOld >> return [

	^ return
]

{ #category : #accessing }
SWSenderOld >> return: anObject [

	return := anObject
]

{ #category : #accessing }
SWSenderOld >> selector [

	^ selector
]

{ #category : #accessing }
SWSenderOld >> selector: anObject [

	selector := anObject
]

{ #category : #accessing }
SWSenderOld >> specifyReturnTypeAs: aType [
	return := SWVariable new: aType
]
