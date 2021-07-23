"
I am a base class of the class that implements a project.s
"
Class {
	#name : #SWClass,
	#superclass : #Object,
	#instVars : [
		'stdout'
	],
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #accessing }
SWClass class >> declarations [
	^ #(print:)
]

{ #category : #'as yet unclassified' }
SWClass class >> rb_print_Using: transpiler [
	transpiler putCode: '\
		puts msg
	\'
]

{ #category : #printing }
SWClass >> print: msg [
	self stdout << msg; cr; flush
]

{ #category : #accessing }
SWClass >> stdout [

	^ stdout ifNil: [ stdout := Transcript ]
]

{ #category : #accessing }
SWClass >> stdout: anObject [

	stdout := anObject
]
