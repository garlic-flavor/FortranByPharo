"
This implements gfortran handler.
"
Class {
	#name : #SWGFortranCompilerAdapter,
	#superclass : #Object,
	#category : #'SWFortranByPharo-ClientServer-Common-CompilerAdapter'
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
