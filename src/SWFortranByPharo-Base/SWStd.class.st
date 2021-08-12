"
I implement stdout.
"
Class {
	#name : #SWStd,
	#superclass : #Object,
	#instVars : [
		'stdout'
	],
	#category : #'SWFortranByPharo-Base'
}

{ #category : #'code generation' }
SWStd class >> rb_error_using: transpiler [
	transpiler putCode: '\
		raise msg
	\'
]

{ #category : #'code generation' }
SWStd class >> rb_print_using: transpiler [
	transpiler putCode: '\
		puts msg
	\'
]

{ #category : #'code generation' }
SWStd class >> rb_requirements [
	^ { 'Pharo.rb' }
]

{ #category : #asserting }
SWStd >> assert: aBlock [
	aBlock value ifFalse: [
		self error: 'Assertion failure: ', aBlock asString
	]
]

{ #category : #'error handling' }
SWStd >> error: msg [
	^ super error: msg
]

{ #category : #printing }
SWStd >> print: msg [
	self stdout << msg asString; cr; flush
]

{ #category : #accessing }
SWStd >> stdout [

	^ stdout ifNil: [ stdout := Transcript ]
]

{ #category : #accessing }
SWStd >> stdout: anObject [

	stdout := anObject
]