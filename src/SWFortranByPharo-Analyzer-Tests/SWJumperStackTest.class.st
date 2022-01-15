Class {
	#name : #SWJumperStackTest,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-Analyzer-Tests-Slot'
}

{ #category : #tests }
SWJumperStackTest >> testBasics [
	|js|
	js := SWJumperStack new.
	js pushAt: 123 period: 234 size: 99.
	self assert: (js nextPeriodIs: 234).
	js update: 345.
	self assert: (js nextPeriodIs: 345).
	self assert: js pop stackSize equals: 99
]
