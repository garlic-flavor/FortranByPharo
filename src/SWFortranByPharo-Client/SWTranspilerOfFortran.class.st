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

]

{ #category : #'code generation' }
SWTranspilerOfFortran >> putArgumentsOf: selector with: arguments [
	self putArray: arguments
]

{ #category : #'code generation' }
SWTranspilerOfFortran >> putArray: anArray [
	self put: (', ' join: (anArray collect: [:each |
		self duplicate transpiledOf: each
	]))
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
