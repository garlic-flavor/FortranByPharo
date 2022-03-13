"
SWMBTofF90 is an implementation of SWMethodBodyTranspiler for Fortran 90.
"
Class {
	#name : #SWMBTofF90,
	#superclass : #SWMethodBodyTranspiler,
	#category : #'SWFortranByPharo-Transpiler-F90'
}

{ #category : #'as yet unclassified' }
SWMBTofF90 >> putStdOut [
	self put: 'print *, '; transpileChildWithoutBracket: self children second

]

{ #category : #'public API' }
SWMBTofF90 >> transpileAsMain [
	self put: 'program '.
	self expression senderInfo putBasenameOn: self stream.
	self cr; incIndent.
	super transpileAsMain.
	self decIndent; put: 'end program '.
	self expression senderInfo putBasenameOn: self stream.
	self cr
]
