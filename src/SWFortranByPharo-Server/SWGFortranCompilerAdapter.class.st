"
This implements gfortran handler.
"
Class {
	#name : #SWGFortranCompilerAdapter,
	#superclass : #SWFortranCompilerAdapter,
	#category : #'SWFortranByPharo-Server-CompilerAdapter'
}

{ #category : #execution }
SWGFortranCompilerAdapter >> compileFortranFile: src to: obj [
	^ SWShell execute: self compiler arguments: (self compilingOptionsFor: src to: obj).
	
]

{ #category : #accessing }
SWGFortranCompilerAdapter >> compiler [
	^ 'gfortran'
]

{ #category : #private }
SWGFortranCompilerAdapter >> compilingOptionsFor: src to: obj [
	^ { '-c'. src fullName. '-o'. obj fullName }
]

{ #category : #execution }
SWGFortranCompilerAdapter >> linkObjs: objs to: exe [
	^ SWShell execute: self compiler arguments: (self linkingOptionsFor: objs to: exe)
]

{ #category : #private }
SWGFortranCompilerAdapter >> linkingOptionsFor: srcs to: exe [
	^ (srcs collect: [:one | one fullName]), { '-o'. exe fullName }
]

{ #category : #querying }
SWGFortranCompilerAdapter >> queryVersion [ 
	| result spec re |
	spec := SWCompilerSpec new name: 'N/A'.
	result := SWShell execute: 'gfortran' arguments: #('--version').
	result isSuccess ifFalse: [ self error: 'gfortran not found. ', result message ].
	re := self regexOfVersionDetection.
	(re matchesPrefix: result message) ifFalse: [ self error: 'unknown version: ', result message ].
	^
	spec
		name: 'GNU Fortran';
		major: (re subexpression: 2) asInteger;
		minor: (re subexpression: 3) asInteger;
		patch: (re subexpression: 4) asInteger.

]

{ #category : #private }
SWGFortranCompilerAdapter >> regexOfVersionDetection [
	^ '^GNU Fortran \([^)]+\)\s+(\d+)\.(\d+)\.(\d+)' asRegex
]

{ #category : #execution }
SWGFortranCompilerAdapter >> runExe: exe [
	^ SWShell execute: exe fullName arguments: #()
]
