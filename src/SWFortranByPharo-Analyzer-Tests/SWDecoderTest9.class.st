Class {
	#name : #SWDecoderTest9,
	#superclass : #SWDecoderTestBase,
	#category : #'SWFortranByPharo-Analyzer-Tests-Analyzer'
}

{ #category : #tests }
SWDecoderTest9 >> test_9001_ston [
	self resultWith: { ReadStream } equals: Dictionary
]
