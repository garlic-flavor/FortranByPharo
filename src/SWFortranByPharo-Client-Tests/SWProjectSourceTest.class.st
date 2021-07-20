"
A SWProjectSourceTest is a test class for testing the behavior of SWProjectSource
"
Class {
	#name : #SWProjectSourceTest,
	#superclass : #TestCase,
	#instVars : [
		'hello'
	],
	#category : #'SWFortranByPharo-Client-Tests-Transpiler'
}

{ #category : #running }
SWProjectSourceTest >> setUp [
	super setUp.
	hello := SWTestHelloWorld new.
	"Put here a common initialization logic for tests"
]

{ #category : #tests }
SWProjectSourceTest >> testCodeGeneration [
	|contents|
	contents := SWTranspilerOfFortran new
		source: hello;
		transpileProgram;
		contents.
	self assert: contents equals: (String crlf join: {
		'program HelloWorld'.
		'    print *, ''Hello, World!'''.
		'end program HelloWorld'.
		''
	})
	
]

{ #category : #tests }
SWProjectSourceTest >> testCodeGenerationOfRuby [
	|contents|
	contents := SWTranspilerOfRuby new
		source: hello;
		transpileProgram;
		contents.
	self assert: contents equals: (String crlf join: {
		'#!/usr/bin/ruby'.
		'puts("Hello, World!")'.
		''
	})
]
