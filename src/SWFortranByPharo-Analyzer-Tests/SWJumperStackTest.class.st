Class {
	#name : #SWJumperStackTest,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-Analyzer-Tests-Slot'
}

{ #category : #tests }
SWJumperStackTest >> testBasics [
	|js|
	js := SWJumperStack new.
	js push: (SWJumperItem new startPC: 123; endPC: 234; yourself).
	self assert: (js nextPeriodIs: 234).

]
