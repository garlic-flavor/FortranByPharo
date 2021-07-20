"
I am a base class of the class that implements a project.s
"
Class {
	#name : #SWProjectSource,
	#superclass : #Object,
	#instVars : [
		'description',
		'view'
	],
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #accessing }
SWProjectSource >> description [
	^ description
]

{ #category : #accessing }
SWProjectSource >> description: aObject [
	description := aObject
]

{ #category : #translating }
SWProjectSource >> f90_print_with: arguments using: transpiler [
	transpiler put: 'print *, '; putArgumentsOf: #print with: arguments.

]

{ #category : #'as yet unclassified' }
SWProjectSource >> functionDeclarations [
	^ #()
]

{ #category : #initialization }
SWProjectSource >> initialize [
	super initialize.
	description := 'This code is generated using Pharo.'.

]

{ #category : #streaming }
SWProjectSource >> print: message [
	view ifNotNil: [
		view << message asString; lf.
	] ifNil: [
		Transcript show: message; cr.
	]

]

{ #category : #running }
SWProjectSource >> program [
	^ self subclassResponsibility
]

{ #category : #translating }
SWProjectSource >> rb_print_with: arguments using: transpiler [
	transpiler putFunctionCallOf: 'puts' with: arguments.

]

{ #category : #accessing }
SWProjectSource >> view [

	^ view
]

{ #category : #accessing }
SWProjectSource >> view: anObject [

	view := anObject
]
