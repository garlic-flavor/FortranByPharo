"
I implement Fortran specific functionality.
My main functionalities are in class side of me.
"
Class {
	#name : #SWFStd,
	#superclass : #Object,
	#category : #'SWFortranByPharo-Client-DomainSpecific'
}

{ #category : #printing }
SWFStd class >> f90_print_With: arguments Using: transpiler [
	transpiler
		put: 'print *, ';
		transpile: (arguments at: 1).
]

{ #category : #printing }
SWFStd class >> print: msg [
	Transcript show: msg; cr.
]

{ #category : #'as yet unclassified' }
SWFStd class >> receiverName [
	^ ''
]
