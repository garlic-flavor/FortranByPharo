"
A SWTypeGroupTest is a test class for testing the behavior of SWTypeGroup
"
Class {
	#name : #SWTypeGroupTest,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-Client-Tests-Deprecated'
}

{ #category : #test }
SWTypeGroupTest >> testLessThanLessThan [

	|g1 g2|
	g1 := SWTypeGroup new.
	g2 := SWTypeGroup new: SmallInteger.
	g1 << g2.
	self assert: g1 value equals: SmallInteger.

]

{ #category : #test }
SWTypeGroupTest >> testPutOn [

	|group|
	group := SWTypeGroup new: SmallInteger with: SWType unknownMethodPriority.
	self assert: [ (String streamContents: [ :s |
		s << group
	]) beginsWith: 'SmallInteger:unknownMethodPriority#' ]
]
