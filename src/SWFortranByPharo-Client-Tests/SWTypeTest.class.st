"
A SWTypeTest is a test class for testing the behavior of SWType
"
Class {
	#name : #SWTypeTest,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-Client-Tests-Analyzer'
}

{ #category : #test }
SWTypeTest >> testPutOn [
	|t|
	t := SWType new: SmallInteger with: SWType exactTypePriority.
	self assert: (String streamContents: [ :s |
		s << t
	]) equals: 'SmallInteger:exactTypePriority'

]
