Class {
	#name : #SWDecoderTestBase,
	#superclass : #TestCase,
	#instVars : [
		'decoder'
	],
	#category : #'SWFortranByPharo-Analyzer-Tests-Analyzer'
}

{ #category : #'as yet unclassified' }
SWDecoderTestBase >> decodeNo: no with: args [
	^ decoder
		method: (SWTestProgram getMy: no);
		operands: (args copyWithFirst: SWTestProgram);
		decode;
		yourself
]

{ #category : #'as yet unclassified' }
SWDecoderTestBase >> noFromSelector: selector [
	^ ((selector copyAfter: $_) copyUpTo: $_) asInteger.

]

{ #category : #'as yet unclassified' }
SWDecoderTestBase >> resultWith: args [
	self decodeNo: (self noFromSelector: thisContext sender selector) with: args.
	self halt.
]

{ #category : #'as yet unclassified' }
SWDecoderTestBase >> resultWith: args equals: type [
	self decodeNo: (self noFromSelector: thisContext sender selector) with: args.
	self assert: decoder sender result value equals: type

]

{ #category : #running }
SWDecoderTestBase >> setUp [
	super setUp.
	decoder := SWDecoder new


]
