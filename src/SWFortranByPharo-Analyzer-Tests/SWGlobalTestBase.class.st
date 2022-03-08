Class {
	#name : #SWGlobalTestBase,
	#superclass : #TestCase,
	#instVars : [
		'global'
	],
	#category : #'SWFortranByPharo-Analyzer-Tests-Analyzer'
}

{ #category : #private }
SWGlobalTestBase >> decode: selector with: args [
	^ global decode: (SWSenderInfo new
		method: (SWTestProgram getBySelector: selector);
		operands: (args copyWithFirst: SWTestProgram);
		yourself)

]

{ #category : #util }
SWGlobalTestBase >> resultWith: args [
	|expression result|
	expression := self decode: thisContext sender selector with: args.
	result := expression messageInfo result.
	self halt.
]

{ #category : #util }
SWGlobalTestBase >> resultWith: args equals: type [
	|decoded messageInfo|
	decoded := self decode: thisContext sender selector with: args.
	messageInfo := decoded messageInfo.
	self assert: messageInfo result value equals: type

]

{ #category : #running }
SWGlobalTestBase >> setUp [
	super setUp.
	global := SWGlobal new


]
