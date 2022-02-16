Class {
	#name : #SWStackOldTest,
	#superclass : #TestCase,
	#instVars : [
		'stack'
	],
	#category : #'SWFortranByPharo-Analyzer-Tests-Slot'
}

{ #category : #initialization }
SWStackOldTest >> setUp [

	| tmp2 |
	super setUp.
	tmp2 := SWStackOld new.
	tmp2
		push: 1;
		push: 2;
		push: 3;
		push: 4.
	stack := tmp2 yourself
]

{ #category : #tests }
SWStackOldTest >> testAt [

	self
		assert: (stack at: 0) equals: 1;
		assert: (stack at: 1) equals: 2;
		assert: (stack at: 3) equals: 4;
		assert: (stack at: 4) value equals: UndefinedObject;
		should: [stack at:  -1] raise: SubscriptOutOfBounds
]

{ #category : #tests }
SWStackOldTest >> testPop [

	stack pop.
	self
		assert: stack asArray equals: { 1. 2. 3 } asArray;
		assert: (stack pop: 2) asArray equals: { 2. 3 }
]

{ #category : #tests }
SWStackOldTest >> testPush [

	stack push: 5.
	self assert: stack asArray equals: { 1. 2. 3. 4. 5 }
]

{ #category : #tests }
SWStackOldTest >> testSize [

	self assert: stack size equals: 4
]

{ #category : #tests }
SWStackOldTest >> testTop [

	self assert: stack top equals: 4
]
