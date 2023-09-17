Class {
	#name : #SWMIofF90,
	#superclass : #SWMessageInfo,
	#instVars : [
		'needsSelf'
	],
	#category : #'SWFortranByPharo-Transpiler-F90'
}

{ #category : #tests }
SWMIofF90 class >> test: aMethod accessTo: aClass [
	aClass isClassSide ifTrue: [ ^ false ].
	aClass = Object ifTrue: [ ^ false ].
	aClass = SWFProgram ifTrue: [ ^ false ].

	(aClass slots anySatisfy: [ :each |
		(aMethod writesSlot: each) or: (aMethod readsSlot: each)
	]) ifTrue: [ ^ true ].

	^ self test: aMethod accessTo: aClass superclass
]

{ #category : #testing }
SWMIofF90 >> isSubroutine [
	^ self result value = self method methodClass
]

{ #category : #'as yet unclassified' }
SWMIofF90 >> mayWriteTo: aVariableName [
	|var|
	var := self method lookupVar: aVariableName.
	var class = ArgumentVariable ifFalse: [ ^ true ].
	^ self method writesField: var index.
]

{ #category : #accessing }
SWMIofF90 >> needsSelf [

	^ needsSelf ifNil: [
		needsSelf := self class test: self method accessTo: self receiverClass
	]
]

{ #category : #accessing }
SWMIofF90 >> needsSelf: anObject [

	needsSelf := anObject
]
