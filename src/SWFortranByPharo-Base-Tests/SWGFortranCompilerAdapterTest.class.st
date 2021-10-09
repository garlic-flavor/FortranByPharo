Class {
	#name : #SWGFortranCompilerAdapterTest,
	#superclass : #TestCase,
	#instVars : [
		'gf',
		'fm',
		'source'
	],
	#category : #'SWFortranByPharo-Base-Tests'
}

{ #category : #running }
SWGFortranCompilerAdapterTest >> setUp [
	super setUp.
	gf := SWGFortranCompilerAdapter.
	source := 'src/native/helloworld.f90'.
	
]

{ #category : #tests }
SWGFortranCompilerAdapterTest >> testCompileFortranFile [
	|src obj res path|
	"ready the source to build."
	path := fm dispatch: source.
	path exists ifTrue: [ path ensureDelete ].
	path writeStream
		nextPutAll: 'program hello'; lf;
		nextPutAll: '    print *, ''Hello, world!'''; lf;
		nextPutAll: 'end program hello'; lf;
		close.

	src := fm dispatch: source.
	obj := fm dispatch: ((Path * source) withExtension: 'o') fullName.
	res := gf compileFortranFiles: {src} to: obj.
	res inspect.
]

{ #category : #tests }
SWGFortranCompilerAdapterTest >> testCompilingOptionsForTo [
	|src obj|
	src := fm dispatch: 'native/helloworld.f90'.
	obj := fm dispatch: 'helloworld.o'.
	self assert: (gf compilingOptionsFor: {src} to: obj) equals: {'-c'. src fullName. '-o'. obj fullName}.
]

{ #category : #tests }
SWGFortranCompilerAdapterTest >> testLinkingFortranFile [
	|obj exe res|
	obj := fm dispatch: 'native/helloworld.o'.
	obj exists ifFalse: [ self error: 'please do "testCompilingFortranFile first.' ].
	exe := fm dispatch: 'a.out'.
	res := gf linkObjs: { obj } to: exe.
	res inspect.
]

{ #category : #tests }
SWGFortranCompilerAdapterTest >> testLinkingOptionsForTo [
	|src1 src2 list exe|
	
	src1 := fm dispatch: 'native/test1.f90'.
	src2 := fm dispatch: 'test2.f90'.
	exe := fm dispatch: 'a.out'.
	list := { src1. src2 }.
	self assert: (gf linkingOptionsFor: list to: exe) equals: { src1 fullName. src2 fullName. '-o'. exe fullName }
]

{ #category : #tests }
SWGFortranCompilerAdapterTest >> testQueryVersion [
	|v|
	v := gf queryVersion.
	self assert: (1 < v major). 
]

{ #category : #tests }
SWGFortranCompilerAdapterTest >> testRegexOfVersionDetection [
	|sample re|
	sample := 'GNU Fortran (Homebrew GCC 11.1.0_1) 11.1.0
Copyright (C) 2021 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.'.
	re := gf regexOfVersionDetection.
	self assert: (re matchesPrefix: sample).
	self assert: (re subexpression: 2) asInteger equals: 11.
	self assert: (re subexpression: 3) asInteger equals: 1.
	self assert: (re subexpression: 4) asInteger equals: 0.
]

{ #category : #tests }
SWGFortranCompilerAdapterTest >> testRunExe [
	|exe res|
	exe := fm dispatch: 'a.out'.
	exe exists ifFalse: [ self error: 'please do testLinkingFortranFile first.' ].
	res := gf runExe: exe.
	self assert: res isSuccess.
]
