"
A SWTypeTest is a test class for testing the behavior of SWType
"
Class {
	#name : #SWTypeTest,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-Client-Tests-Analyzer'
}

{ #category : #tests }
SWTypeTest >> testBasics [
	|type1|
	type1 := SWType new: SmallInteger.
	self assert: type1 value equals: SmallInteger.
	self assert: type1 priority equals: SWType exactTypePriority.

	type1 := SWType new: nil.
	self assert: type1 value equals: nil.
	self assert: type1 priority equals: SWType defaultPriority.

	type1 := SWType new: nil class.
	self assert: type1 value equals: UndefinedObject.
	self assert: type1 priority equals: SWType defaultPriority.
	
	type1 := SWType new: [ 1234 class ].
	self assert: type1 priority equals: SWType unknownMethodPriority.
	self assert: type1 easyValue equals: nil.
	self assert: type1 value equals: SmallInteger.
	self assert: type1 priority equals: SWType exactTypePriority.
	
]

{ #category : #test }
SWTypeTest >> testPutOn [
	|t|
	t := SWType new: SmallInteger with: SWType exactTypePriority.
	self assert: (String streamContents: [ :s |
		s << t
	]) equals: 'SmallInteger:exactTypePriority'

]
