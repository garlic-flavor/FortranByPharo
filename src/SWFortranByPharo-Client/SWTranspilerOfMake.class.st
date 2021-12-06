Class {
	#name : #SWTranspilerOfMake,
	#superclass : #SWTranspiler,
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #'code generation' }
SWTranspilerOfMake >> putClassDefinition: arg1 [

	
]

{ #category : #'public API' }
SWTranspilerOfMake >> putProgram: arg1 [

	
]

{ #category : #'code generation' }
SWTranspilerOfMake >> putRequirements [

	| tmp1 tmp2 |
	tmp1 := ((Path from: self source filename) withExtension:
		         SWShellEnvironment default exeFileExtension) fullName.
	tmp2 := ((Path from: self source filename) withExtension:
		         SWShellEnvironment default objFileExtension) fullName.
	self
		put: 'run: ';
		putLine: tmp1;
		put: String tab;
		putLine: './$^';
		type: self source type.
	super putRequirements.
	self
		putLine;
		put: tmp1;
		put: ' : ';
		putLine: tmp2;
		putLine;
		putLine: '%.out :';
		put: String tab;
		putLine: 'gfortran -o $@ $^';
		putLine;
		putLine: '%.o : %.f90';
		put: String tab;
		putLine: 'gfortran -c -o $@ $?'
]
