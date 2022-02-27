Class {
	#name : #SWValueTest,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-Analyzer-Tests-Type'
}

{ #category : #'instance creation' }
SWValueTest >> newValueWith: anObject [
	^ SWValue new
		<< anObject;
		yourself.
]

{ #category : #tests }
SWValueTest >> testAssignmentAndEquality [
	|v1 v2|
	v1 := SWValue new.
	v2 := SWValue new.
	v1 << Integer.
	v2 << v1.
	v1 << String.
	self assert: v2 value equals: String.
]

{ #category : #tests }
SWValueTest >> testAssingment [

	self assert: (self newValueWith: Integer) value equals: Integer.
	self assert: (self newValueWith: (SWType new: Float)) value equals: Float.
	self assert: (self newValueWith: (self newValueWith: Integer)) value equals: Integer.
	self assert: (self newValueWith: (SWVariable new: String)) value equals: String.
]
