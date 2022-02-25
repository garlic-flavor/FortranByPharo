Class {
	#name : #SWDecoderTestBase,
	#superclass : #TestCase,
	#instVars : [
		'decoder'
	],
	#category : #'SWFortranByPharo-Analyzer-Tests-Analyzer'
}

{ #category : #'as yet unclassified' }
SWDecoderTestBase >> decode: selector with: args [
	^ decoder
		method: (SWTestProgram getBySelector: selector);
		operands: (args copyWithFirst: SWTestProgram);
		decode;
		yourself
]

{ #category : #'as yet unclassified' }
SWDecoderTestBase >> resultWith: args [
	self decode: thisContext sender selector with: args.
	self halt.
]

{ #category : #'as yet unclassified' }
SWDecoderTestBase >> resultWith: args equals: type [
	self decode: thisContext sender selector with: args.
	self assert: decoder sender result value equals: type

]

{ #category : #running }
SWDecoderTestBase >> setUp [
	super setUp.
	decoder := SWDecoder new


]
