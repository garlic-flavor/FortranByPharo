"
I generate makefile.
"
Class {
	#name : #SWTranspilerOfMake,
	#superclass : #SWTranspiler,
	#category : #'SWFortranByPharo-Client'
}

{ #category : #'code generation' }
SWTranspilerOfMake >> putClassDefinition: aClass [
]

{ #category : #'public API' }
SWTranspilerOfMake >> putProgram: aClass [
]

{ #category : #'code generation' }
SWTranspilerOfMake >> putRequirements [
	|exeName objName|
	exeName := ((Path from: self source filename) withExtension: SWShellEnvironment default exeFileExtension) fullName.
	objName := ((Path from: self source filename) withExtension: SWShellEnvironment default objFileExtension) fullName.
	self
		put: 'run: ';
		putLine: exeName;
		put: String tab;
		putLine: './$^'.

	self type: self source type.
	super putRequirements.

	self
		putLine;
		put: exeName;
		put: ' : ';
		putLine: objName.

	self
		putLine;
		putLine: '%.out :';
		put: String tab; putLine: 'gfortran -o $@ $^';
		putLine;
		putLine: '%.o : %.f90';
		put: String tab; putLine: 'gfortran -c -o $@ $?'.
]
