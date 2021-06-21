"
I am a base class of the class that implements a project.s
"
Class {
	#name : #SWProjectSource,
	#superclass : #Object,
	#instVars : [
		'type',
		'description',
		'view'
	],
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #accessing }
SWProjectSource >> code [
	^ SWTranspiler transpile: self
]

{ #category : #accessing }
SWProjectSource >> description [
	^ description
]

{ #category : #accessing }
SWProjectSource >> description: aObject [
	description := aObject
]

{ #category : #printing }
SWProjectSource >> f90_print_with: arguments using: transpiler [
	transpiler put: 'print *, '; putArgumentsOf: #print with: arguments.

]

{ #category : #initialization }
SWProjectSource >> initialize [
	super initialize.
	type := #f90.
	description := 'This code is generated using Pharo.'.

]

{ #category : #streaming }
SWProjectSource >> print: message [
	view ifNotNil: [
		view << message 
	] ifNil: [
		Transcript show: message; cr.
	]

]

{ #category : #running }
SWProjectSource >> program [
	^ self subclassResponsibility
]

{ #category : #printing }
SWProjectSource >> rb_print_with: arguments using: transpiler [
	transpiler putFunctionCallOf: 'puts' with: arguments.

]

{ #category : #accessing }
SWProjectSource >> type [
	^ type
]

{ #category : #accessing }
SWProjectSource >> type: aObject [
	type := aObject
]

{ #category : #accessing }
SWProjectSource >> view [

	^ view
]

{ #category : #accessing }
SWProjectSource >> view: anObject [

	view := anObject
]
