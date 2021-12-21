"
A SWTypeGroupTest is a test class for testing the behavior of SWTypeGroup
"
Class {
	#name : #SWTypeGroupTest,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-Client-Tests-Analyzer'
}

{ #category : #test }
SWTypeGroupTest >> testPutOn [

	|group|
	group := SWTypeGroup new.
	group type: SmallInteger; priority: SWType unknownMethodPriority.
	self assert: [ (String streamContents: [ :s |
		s << group
	]) beginsWith: 'SmallInteger:unknownMethodPriority#' ]
]
