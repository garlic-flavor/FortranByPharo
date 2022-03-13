"
SWMBTofF90 is an implementation of SWMethodBodyTranspiler for Fortran 90.
"
Class {
	#name : #SWMBTofF90,
	#superclass : #SWMethodBodyTranspiler,
	#category : #'SWFortranByPharo-Transpiler-F90'
}

{ #category : #'public API' }
SWMBTofF90 >> transpileAsMain [
	self put: 'program '.
	self expression senderInfo putBasenameOn: self stream.
	self cr; incIndent.
	super transpileAsMain.
	self decIndent; put: 'end program'; cr
]
