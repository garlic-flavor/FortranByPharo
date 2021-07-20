"
This transpile Pharo to Fortran.
"
Class {
	#name : #SWTranspilerOfFortran,
	#superclass : #SWTranspiler,
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #initialization }
SWTranspilerOfFortran >> initialize [
	super initialize. 
	self type: #f90.
]

{ #category : #'code generation' }
SWTranspilerOfFortran >> putArgumentsOf: selector with: arguments [
	^ self putArray: arguments
]

{ #category : #'code generation' }
SWTranspilerOfFortran >> putFunctionCallFooterOf: selector [
	self put: ')'
]

{ #category : #'code generation' }
SWTranspilerOfFortran >> putFunctionCallHeaderOf: name [
	self put: name; put: '('.

]

{ #category : #'code generation' }
SWTranspilerOfFortran >> putMainProgramFooterOf: project [
	self
		put: 'end program ';
		putLine: project.
]

{ #category : #'code generation' }
SWTranspilerOfFortran >> putMainProgramHeaderOf: project [
	self
		put: 'program ';
		putLine: project.
]

{ #category : #'as yet unclassified' }
SWTranspilerOfFortran >> putString: aString [
	self
		put: '''';
		put: aString;
		put: ''''.
]
