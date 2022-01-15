"
A SWCalleeInfoTest is a test class for testing the behavior of SWCalleeInfo
"
Class {
	#name : #SWCalleeInfoTest,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-Analyzer-Tests-Analyzer'
}

{ #category : #tests }
SWCalleeInfoTest >> testEquality [
	|ci1 ci2|
	ci1 := SWCalleeInfo new: SmallInteger>>#+ with: { SmallInteger. SmallInteger }.
	ci2 := SWCalleeInfo new: SmallInteger>>#+ with: { SmallInteger. SmallInteger }.
	self assert: ci1 equals: ci2.
	
	ci1 := SWCalleeInfo new: #at:ifAbsent: with: #().
	ci2 := SWCalleeInfo new: #at:ifAbsent: with: #().
	self assert: ci1 equals: ci2.
]
