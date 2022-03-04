Class {
	#name : #SWDecoderTestBase,
	#superclass : #TestCase,
	#instVars : [
		'global'
	],
	#category : #'SWFortranByPharo-Analyzer-Tests-Analyzer'
}

{ #category : #private }
SWDecoderTestBase >> decode: selector with: args [
	^ global decode: (SWSenderInfo new
		method: (SWTestProgram getBySelector: selector);
		operands: (args copyWithFirst: SWTestProgram);
		yourself)

]

{ #category : #util }
SWDecoderTestBase >> resultWith: args [
	|expression result|
	expression := self decode: thisContext sender selector with: args.
	result := expression messageInfo result.
	self halt.
]

{ #category : #util }
SWDecoderTestBase >> resultWith: args equals: type [
	|decoded messageInfo|
	decoded := self decode: thisContext sender selector with: args.
	messageInfo := decoded messageInfo.
	self assert: messageInfo result value equals: type

]

{ #category : #running }
SWDecoderTestBase >> setUp [
	super setUp.
	global := SWGlobal new


]
