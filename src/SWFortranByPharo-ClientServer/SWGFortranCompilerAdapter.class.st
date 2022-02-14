"
This implements gfortran handler.
"
Class {
	#name : #SWGFortranCompilerAdapter,
	#superclass : #Object,
	#instVars : [
		'env',
		'src',
		'obj',
		'exe',
		'basename',
		'srcDir',
		'objDir',
		'exeDir',
		'contents'
	],
	#category : #'SWFortranByPharo-ClientServer-Shell'
}

{ #category : #compiling }
SWGFortranCompilerAdapter class >> compileFortranFiles: srcs to: obj [
	^ SWShell execute: self compilerName arguments: (self compilingOptionsFor: srcs to: obj).
	
]

{ #category : #accessing }
SWGFortranCompilerAdapter class >> compilerName [
	^ 'gfortran'
]

{ #category : #private }
SWGFortranCompilerAdapter class >> compilingOptionsFor: srcs to: obj [
	^ (srcs collect: [:each | {'-c'. each fullName}]) flattened, { '-o'. obj fullName}

]

{ #category : #execution }
SWGFortranCompilerAdapter class >> linkObjs: objs to: exe [
	^ SWShell execute: self compilerName arguments: (self linkingOptionsFor: objs to: exe)
]

{ #category : #private }
SWGFortranCompilerAdapter class >> linkingOptionsFor: srcs to: exe [
	^ (srcs collect: [:one | one fullName]), { '-o'. exe fullName }
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
SWGFortranCompilerAdapter class >> runExe: exe [
	^ SWShell execute: exe fullName arguments: #()
]

{ #category : #accessing }
SWGFortranCompilerAdapter >> basename [

	^ basename
]

{ #category : #accessing }
SWGFortranCompilerAdapter >> basename: anObject [

	basename := anObject
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

	^ env ifNil: [ env := SWShellEnvironment default ]
]

{ #category : #accessing }
SWGFortranCompilerAdapter >> env: anObject [

	env := anObject
]

{ #category : #accessing }
SWGFortranCompilerAdapter >> exe [

	^ exe
]

{ #category : #accessing }
SWGFortranCompilerAdapter >> exe: anObject [

	exe := anObject
]

{ #category : #accessing }
SWGFortranCompilerAdapter >> exeDir [

	^ exeDir ifNil: [ exeDir := 'cache/bin' ]
]

{ #category : #accessing }
SWGFortranCompilerAdapter >> exeDir: anObject [

	exeDir := anObject
]

{ #category : #accessing }
SWGFortranCompilerAdapter >> obj [

	^ obj
]

{ #category : #accessing }
SWGFortranCompilerAdapter >> obj: anObject [

	obj := anObject
]

{ #category : #accessing }
SWGFortranCompilerAdapter >> objDir [

	^ objDir ifNil: [ objDir := 'cache/obj' ]
]

{ #category : #accessing }
SWGFortranCompilerAdapter >> objDir: anObject [

	objDir := anObject
]

{ #category : #accessing }
SWGFortranCompilerAdapter >> src [

	^ src
]

{ #category : #accessing }
SWGFortranCompilerAdapter >> src: anObject [

	src := anObject
]

{ #category : #accessing }
SWGFortranCompilerAdapter >> srcDir [

	^ srcDir ifNil: [ srcDir := 'cache/src' ]
]

{ #category : #accessing }
SWGFortranCompilerAdapter >> srcDir: anObject [

	srcDir := anObject
]
