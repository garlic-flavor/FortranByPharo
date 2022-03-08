Class {
	#name : #SWGlobalTest9,
	#superclass : #SWGlobalTestBase,
	#category : #'SWFortranByPharo-Analyzer-Tests-Analyzer'
}

{ #category : #tests }
SWGlobalTest9 >> test_9001_ston [
	self resultWith: { ReadStream } equals: Dictionary
]
