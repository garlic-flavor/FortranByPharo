"
SWMTofF90 is an implementation of SWModuleTranspiler for Fortran 90.
"
Class {
	#name : #SWMTofF90,
	#superclass : #SWModuleTranspiler,
	#category : #'SWFortranByPharo-Transpiler-F90'
}

{ #category : #'as yet unclassified' }
SWMTofF90 class >> poolClass [
	^ SWPoolOfF90
]

{ #category : #'as yet unclassified' }
SWMTofF90 >> transpilePayload [
	self error; flag: #toRemove.
	self stream
		put: 'program ';
		put: self basename;
		putLine;
		incIndent.
	super transpilePayload.
	self stream
		decIndent;
		put: 'end program ';
		put: self basename;
		putLine
]
