Class {
	#name : #SWExpressionTest,
	#superclass : #TestCase,
	#instVars : [
		'expression'
	],
	#category : #'SWFortranByPharo-Analyzer-Tests-Analyzer'
}

{ #category : #running }
SWExpressionTest >> setUp [
	super setUp.
	expression := SWExpression new
	"Put here a common initialization logic for tests"
]

{ #category : #tests }
SWExpressionTest >> testAddToSlot [
	expression addToSlot: 'hoge' as: Integer.
	expression addToSlot: 'fuga' as: Dictionary.
	expression addToSlot: 'self' as: SWExpression.
	
	self assert: (expression containsAsMember: 'fuga').
	self deny: (expression containsAsMember: 'self').
	self deny: (expression containsAsMember: 'moooo').
]
