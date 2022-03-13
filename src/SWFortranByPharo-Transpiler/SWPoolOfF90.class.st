"
An implementation of transpiler pool for Fortran.
"
Class {
	#name : #SWPoolOfF90,
	#superclass : #SWTranspilerPool,
	#category : #'SWFortranByPharo-Transpiler-F90'
}

{ #category : #constants }
SWPoolOfF90 class >> classInfoClass [
	^ SWCDTofF90
]

{ #category : #constants }
SWPoolOfF90 class >> mangleClass [
	^ SWMangleOfF90
]

{ #category : #constants }
SWPoolOfF90 class >> methodBodyTranspilerClass [
	^ SWMBTofF90
]
