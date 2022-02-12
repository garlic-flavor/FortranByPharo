"
A SWTypeTest is a test class for testing the behavior of SWType
"
Class {
	#name : #SWTypeTest,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-Analyzer-Tests-Type'
}

{ #category : #tests }
SWTypeTest >> testBasics [
	|type1|
	type1 := SWType new: SmallInteger.
	self assert: type1 value equals: SmallInteger.
	self assert: type1 priority equals: SWType exactTypePriority.

	type1 := SWType new: nil.
	self assert: type1 value equals: nil class.
	self assert: type1 priority equals: SWType defaultPriority.

	type1 := SWType new: nil class.
	self assert: type1 value equals: UndefinedObject.
	self assert: type1 priority equals: SWType defaultPriority.

]

{ #category : #test }
SWTypeTest >> testLessThanLessThan [

	|type1 type2|
	type1 := SWType new: SmallInteger.
	type1 << Integer.
	self assert: type1 value equals: Integer.

	type2 := SWType new: String.
	type1 << type2.
	self assert: type1 value equals: Integer.
	
	type1 priority: SWType defaultPriority.
	type1 << type2.
	self assert: type1 value equals: String.
	self assert: type1 priority equals: SWType exactTypePriority.

]

{ #category : #tests }
SWTypeTest >> testNameOfPriority [
	(SWType class methodDict valuesDo: [ :m |
		m protocol = #constants ifTrue: [|val|
			val := m valueWithReceiver: SWType arguments: #().
			self assert: (SWType nameOfPriority: val) equals: (m selector copyUpToSubstring: 'Priority')
		]
	])
]

{ #category : #test }
SWTypeTest >> testPutOn [
	|t|
	t := SWType new: SmallInteger with: SWType exactTypePriority.
	self assert: (String streamContents: [ :s |
		s << t
	]) equals: 'SmallInteger:exactType'

]
