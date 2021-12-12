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
SWFStd class >> f90_print_With: arguments Using: transpiler [
	transpiler
		put: 'print *, ';
		transpile: (arguments at: 1)
]

{ #category : #'as yet unclassified' }
SWFStd class >> import: identifiers from: aFile [
]

{ #category : #'as yet unclassified' }
SWFStd class >> js_import_from_With: arguments Using: transpiler [
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
