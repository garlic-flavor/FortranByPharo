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
	^ global getMessageInfo: (SWSenderInfo new
		method: (SWTestProgram getBySelector: selector);
		operands: (args copyWithFirst: SWTestProgram);
		yourself)

]

{ #category : #util }
SWDecoderTestBase >> resultWith: args [
	|messageInfo|
	messageInfo := self decode: thisContext sender selector with: args.
	self halt.
]

{ #category : #util }
SWDecoderTestBase >> resultWith: args equals: type [
	|messageInfo|
	messageInfo := self decode: thisContext sender selector with: args.
	self assert: messageInfo result value equals: type

]

{ #category : #running }
SWDecoderTestBase >> setUp [
	super setUp.
	global := SWGlobal new


]
