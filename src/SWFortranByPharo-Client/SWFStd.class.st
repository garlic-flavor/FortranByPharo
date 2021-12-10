"
I implement Fortran specific functionality.
My main functionalities are in class side of me.
"
Class {
	#name : #SWFStd,
	#superclass : #Object,
	#category : #'SWFortranByPharo-Client-DomainSpecific'
}

{ #category : #'as yet unclassified' }
SWFStd class >> a_declare_With: arguments Using: transpiler [
]

{ #category : #'code generation - property' }
SWFStd class >> declare: properties [
	^ properties detect: [ :p | p isAssociation  and: [p key = #value ]] ifFound: [ :p | p value ] ifNone: [ nil ]
]

{ #category : #'code generation - property' }
SWFStd class >> f90_declare_With: arguments Using: transpiler [

]

{ #category : #'as yet unclassified' }
SWFStd class >> f90_print_With: arguments Using: transpiler [
	transpiler
		put: 'print *, ';
		transpile: (arguments at: 1)
]

{ #category : #'as yet unclassified' }
SWFStd class >> js_print_With: arguments Using: transpiler [
	transpiler
		put: 'console.log';
		putArguments: arguments
		
]

{ #category : #printing }
SWFStd class >> print: msg [
	Transcript show: msg; cr.
]
