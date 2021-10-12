"
I implement Fortran specific functionality.
My main functionalities are in class side of me.
"
Class {
	#name : #SWFStd,
	#superclass : #Object,
	#category : #'SWFortranByPharo-Client-DomainSpecific'
}

{ #category : #'code generation - property' }
SWFStd class >> declare: aSymbol as: aType [
]

{ #category : #'code generation - property' }
SWFStd class >> f90_declare_as_With: arguments Using: transpiler [
	transpiler logger log.
	transpiler
		put: (arguments at: 2) value;
		put: ' ';
		put: (arguments at: 1) value
]

{ #category : #'code generation - property' }
SWFStd class >> f90_print_Using: transpiler [
	transpiler putLine: 'print *, msg'.

]

{ #category : #printing }
SWFStd class >> print: msg [
	Transcript show: msg; cr.
]

{ #category : #'code generation - property' }
SWFStd class >> returnTypeOf: aSelector with: argumentTypes [
	aSelector == #print: ifTrue: [
		^ nil
	].
	^ nil
]
