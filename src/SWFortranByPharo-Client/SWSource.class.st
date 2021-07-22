"
I am a base class of the class that implements a project.s
"
Class {
	#name : #SWSource,
	#superclass : #Object,
	#instVars : [
		'description',
		'view'
	],
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #'as yet unclassified' }
SWSource >> declare: aSymbolName asKindOf: dummyInstance [
]

{ #category : #accessing }
SWSource >> description [
	^ description
]

{ #category : #accessing }
SWSource >> description: aObject [
	description := aObject
]

{ #category : #translating }
SWSource >> f90_print_with: arguments using: transpiler [
	transpiler put: 'print *, '; putArgumentsOf: #print with: arguments.

]

{ #category : #'as yet unclassified' }
SWSource >> fileHeaders [
	^ {  }
]

{ #category : #'as yet unclassified' }
SWSource >> functionDeclarations [
	^ #()
]

{ #category : #initialization }
SWSource >> initialize [
	super initialize.
	description := 'This code is generated using Pharo.'.

]

{ #category : #streaming }
SWSource >> print: message [
	view ifNotNil: [
		view << message asString; lf.
	] ifNil: [
		Transcript show: message; cr.
	]

]

{ #category : #running }
SWSource >> program [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SWSource >> putCode: code with: anAssociationArray of: type for: aBlock [
	^ aBlock value

]

{ #category : #'as yet unclassified' }
SWSource >> rb_declare_asKindOf_with: arguments using: transpiler [
	transpiler preventNewline.
	^ transpiler variables at: (arguments at: 1) value put: (arguments at: 2) value.

]

{ #category : #translating }
SWSource >> rb_print_with: arguments using: transpiler [
	transpiler putFunctionCallOf: 'puts' with: arguments.

]

{ #category : #'as yet unclassified' }
SWSource >> rb_putCode_with_of_for_with: arguments using: transpiler [
	(arguments at: 3) evaluate = #rb ifFalse: [ ^ self ].
	^ transpiler putCode: (arguments at: 1) evaluate with: (arguments at: 2) evaluate
]

{ #category : #accessing }
SWSource >> view [

	^ view
]

{ #category : #accessing }
SWSource >> view: anObject [

	view := anObject
]
