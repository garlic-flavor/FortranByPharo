"
I implement Fortran specific functionality.
My main functionalities are in class side of me.
"
Class {
	#name : #SWStd,
	#superclass : #Object,
	#category : #'SWFortranByPharo-ClientServer-Common'
}

{ #category : #'code generation' }
SWStd class >> f90_print_With: arguments Using: transpiler [
	transpiler
		put: 'print *, ';
		transpile: (arguments at: 1)
]

{ #category : #'code generation' }
SWStd class >> import: identifiers from: aFile [
]

{ #category : #initialization }
SWStd class >> initializeClassSideTranspiler: transpiler [
	transpiler
		defineMethod: #print: as: self with: [ :t :aNode |
			t putStdOut: aNode arguments
		]
]

{ #category : #'code generation' }
SWStd class >> js_import_from_With: arguments Using: transpiler [
	transpiler put: 'import {'.
	(arguments at: 1) value do: [ :each |
		transpiler put: each asString
	] separatedBy: [
		transpiler put: ', '
	].
	transpiler
		put: '} from ''../../script/';
		put: (arguments at: 2) value;
		put: ''''
]

{ #category : #printing }
SWStd class >> print: msg [
	Transcript show: msg; cr.
]
