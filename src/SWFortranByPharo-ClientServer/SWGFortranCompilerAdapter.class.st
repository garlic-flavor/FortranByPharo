"
This implements gfortran handler.
"
Class {
	#name : #SWGFortranCompilerAdapter,
	#superclass : #Object,
	#instVars : [
		'env',
		'src',
		'exe',
		'basename',
		'rootDir',
		'srcDir',
		'exeDir',
		'contents'
	],
	#category : #'SWFortranByPharo-ClientServer-Shell'
}

{ #category : #compiling }
SWGFortranCompilerAdapter class >> compile: srcs to: exe [
	^ SWShell execute: self compilerName arguments: (self compilingOptionsFor: srcs to: exe).
	
]

{ #category : #accessing }
SWGFortranCompilerAdapter class >> compilerName [
	^ 'gfortran'
]

{ #category : #private }
SWGFortranCompilerAdapter class >> compilingOptionsFor: srcs to: exe [
	^ (srcs collect: [ :each | (SWShell filePathOf: each) fullName ]), { '-o'. (SWShell filePathOf: exe) fullName }
	

]

{ #category : #querying }
SWGFortranCompilerAdapter class >> queryVersion [ 
	| result spec re |
	spec := SWCompilerSpec new name: 'N/A'.
	result := SWShell execute: self compilerName arguments: #('--version').
	re := self regexOfVersionDetection.
	(re matchesPrefix: result) ifFalse: [ self error: 'unknown version: ', result message ].
	^ spec
		name: 'GNU Fortran';
		type: 'f';
		major: (re subexpression: 2) asInteger;
		minor: (re subexpression: 3) asInteger;
		patch: (re subexpression: 4) asInteger;
		yourself.

]

{ #category : #private }
SWGFortranCompilerAdapter class >> regexOfVersionDetection [
	^ '^GNU Fortran \([^)]+\)\s+(\d+)\.(\d+)\.(\d+)' asRegex
]

{ #category : #execution }
SWGFortranCompilerAdapter class >> run: exe [
	^ SWShell execute: (SWShell filePathOf: exe) fullName arguments: #()
]

{ #category : #accessing }
SWGFortranCompilerAdapter >> basename [

	^ basename
]

{ #category : #accessing }
SWGFortranCompilerAdapter >> basename: anObject [

	basename := anObject
]

{ #category : #actions }
SWGFortranCompilerAdapter >> compile [
	^ self class compile: { self src } to: self exe
]

{ #category : #accessing }
SWGFortranCompilerAdapter >> contents [

	^ contents
]

{ #category : #accessing }
SWGFortranCompilerAdapter >> contents: anObject [

	contents := anObject
]

{ #category : #accessing }
SWGFortranCompilerAdapter >> env [

	^ env ifNil: [ env := SWOS default ]
]

{ #category : #accessing }
SWGFortranCompilerAdapter >> env: anObject [

	env := anObject
]

{ #category : #accessing }
SWGFortranCompilerAdapter >> exe [

	^ exe ifNil: [ exe := ((Path from: self rootDir) / self exeDir / self basename, self env exeFileExtension) fullName ]
]

{ #category : #accessing }
SWGFortranCompilerAdapter >> exe: anObject [

	exe := anObject
]

{ #category : #accessing }
SWGFortranCompilerAdapter >> exeDir [

	^ exeDir ifNil: [ exeDir := 'bin' ]
]

{ #category : #accessing }
SWGFortranCompilerAdapter >> exeDir: anObject [

	exeDir := anObject
]

{ #category : #actions }
SWGFortranCompilerAdapter >> put [
	^ SWShell put: self src contents: self contents
]

{ #category : #accessing }
SWGFortranCompilerAdapter >> rootDir [

	^ rootDir ifNil: [ rootDir := 'cache' ]
]

{ #category : #accessing }
SWGFortranCompilerAdapter >> rootDir: anObject [

	rootDir := anObject
]

{ #category : #actions }
SWGFortranCompilerAdapter >> run [
	^ self class run: self exe
]

{ #category : #accessing }
SWGFortranCompilerAdapter >> src [

	^ src ifNil: [ src := ((Path from: self rootDir) / self srcDir / self basename , 'f90' ) fullName ]
]

{ #category : #accessing }
SWGFortranCompilerAdapter >> src: anObject [

	src := anObject
]

{ #category : #accessing }
SWGFortranCompilerAdapter >> srcDir [

	^ srcDir ifNil: [ srcDir := 'src' ]
]

{ #category : #accessing }
SWGFortranCompilerAdapter >> srcDir: anObject [

	srcDir := anObject
]
