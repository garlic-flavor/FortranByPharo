"
A SWStackTest is a test class for testing the behavior of SWStack
"
Class {
	#name : #SWStackTest,
	#superclass : #TestCase,
	#instVars : [
		'stack'
	],
	#category : #'SWFortranByPharo-Client-Tests-Analyzer'
}

{ #category : #initialization }
SWStackTest >> setUp [
	super setUp.
	stack := SWStack new
		push: 1;
		push: 2;
		push: 3;
		push: 4;
		yourself

]

{ #category : #tests }
SWStackTest >> testAsOrderedCollection [
	self assert: stack asOrderedCollection equals: { 1. 2. 3. 4 } asOrderedCollection
]

{ #category : #tests }
SWStackTest >> testAt [
	self assert: (stack at: -1) equals: 1.
	self assert: (stack at: 0) equals: 2.
	self assert: (stack at: 2) equals: 4.
	self assert: (stack at: 3) equals: nil.
	self assert: (stack at: -2) equals: nil.
]

{ #category : #tests }
SWStackTest >> testPop [
	stack pop.
	self assert: stack asOrderedCollection equals: { 1. 2. 3 } asOrderedCollection.
	self assert: (stack pop: 2) equals: { 2. 3 } asOrderedCollection.
	
]

{ #category : #tests }
SWStackTest >> testPush [
	stack push: 5.
	self assert: stack asOrderedCollection equals: { 1. 2. 3. 4. 5 } asOrderedCollection 
]

{ #category : #tests }
SWStackTest >> testSize [
	self assert: stack size equals: 4.
]

{ #category : #tests }
SWStackTest >> testTop [
	self assert: stack top equals: 4.
]
