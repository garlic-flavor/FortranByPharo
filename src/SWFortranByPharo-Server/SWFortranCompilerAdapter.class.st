"
This implements an adapter handling fortran compiler(e.g. gfortran).
"
Class {
	#name : #SWFortranCompilerAdapter,
	#superclass : #Object,
	#category : #'SWFortranByPharo-Server-CompilerAdapter'
}

{ #category : #compiling }
SWFortranCompilerAdapter >> compileFortranFile: src to: obj [
	^ SubclassResponsibility 
]

{ #category : #querying }
SWFortranCompilerAdapter >> queryVersion [
	^ SubclassResponsibility
]
