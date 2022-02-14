Class {
	#name : #SWGFortranCompilerAdapterTest,
	#superclass : #TestCase,
	#instVars : [
		'adapter'
	],
	#category : #'SWFortranByPharo-ClientServer-Tests-Shell'
}

{ #category : #running }
SWGFortranCompilerAdapterTest >> setUp [
	super setUp.
	adapter := SWGFortranCompilerAdapter new
		basename: 'hello';
		contents: ('program hello
    print *, ''Hello, world!''
end
' copyReplaceAll: String cr with: String crlf);
		yourself

]

{ #category : #tests }
SWGFortranCompilerAdapterTest >> testCompileTo [
	|res|
	"ready the source to build."
	adapter put.
	res := adapter compile.
	self assert: (SWShell filePathOf: adapter exe) exists
]

{ #category : #tests }
SWGFortranCompilerAdapterTest >> testCompilingOptionsForTo [
	|src obj ops|
	src := 'helloworld.f90'.
	obj := 'helloworld.o'.
	ops := SWGFortranCompilerAdapter compilingOptionsFor: {src} to: obj.
	self assert: (Path from: ops first) basename equals: src.
	self assert: ops second equals: '-o'.
	self assert: (Path from: ops third) basename equals: obj.
]

{ #category : #tests }
SWGFortranCompilerAdapterTest >> testPut [
	|file|
	file := adapter put.
	self assert: file basename equals: 'hello.f90'.
	self assert: file exists
]

{ #category : #tests }
SWGFortranCompilerAdapterTest >> testQueryVersion [
	|v|
	v := SWGFortranCompilerAdapter queryVersion.
	self assert: (1 < v major). 
]

{ #category : #tests }
SWGFortranCompilerAdapterTest >> testRegexOfVersionDetection [
	|sample re|
	sample := 'GNU Fortran (Homebrew GCC 11.1.0_1) 11.1.0
Copyright (C) 2021 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.'.
	re := SWGFortranCompilerAdapter regexOfVersionDetection.
	self assert: (re matchesPrefix: sample).
	self assert: (re subexpression: 2) asInteger equals: 11.
	self assert: (re subexpression: 3) asInteger equals: 1.
	self assert: (re subexpression: 4) asInteger equals: 0.
]

{ #category : #tests }
SWGFortranCompilerAdapterTest >> testRun [
	|res|
	adapter put.
	adapter compile.
	res := adapter run.
	self assert: res trimBoth equals: 'Hello, world!'
]
