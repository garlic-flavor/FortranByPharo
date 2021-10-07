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
	self logger log.
	^ self putArray: arguments
]

{ #category : #'code generation' }
SWTranspilerOfFortran >> putClassDefinition: aClass [
	self logger log.
	
]

{ #category : #'public API' }
SWTranspilerOfFortran >> putProgram: aClass [
	self logger log.
	self
		put: 'program ';
		putLine: self source moduleName;
		putSequence: (aClass class methodDictionary at: #program) sourceNode body;
		put: 'end program ';
		putLine: self source moduleName
]

{ #category : #'code generation' }
SWTranspilerOfFortran >> putSequence: aSequence [
	self logger log.
	self incIndent.
	aSequence children do: [ :child |
		self
			transpile: child;
			putLine
	].
	self decIndent
]

{ #category : #'as yet unclassified' }
SWTranspilerOfFortran >> putString: aString [
	self
		put: '''';
		put: aString;
		put: ''''.
]
