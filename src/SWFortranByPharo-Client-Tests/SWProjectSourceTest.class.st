Class {
	#name : #SWProjectSourceTest,
	#superclass : #TestCase,
	#instVars : [
		'hello'
	],
	#category : #'SWFortranByPharo-Client-Tests-Deprecated'
}

{ #category : #running }
SWProjectSourceTest >> setUp [

	super setUp.
	hello := SWTestHelloWorld new
]

{ #category : #tests }
SWProjectSourceTest >> testCodeGeneration [

	| tmp1 tmp3 |
	tmp3 := SWTranspilerOfFortran new.
	tmp3
		source: hello;
		transpileProgram.
	tmp1 := tmp3 contents.
	self assert: tmp1 equals: (String crlf join:
			 { 'program HelloWorld'. '    print *, ''Hello, World!'''.
			 'end program HelloWorld'. '' })
]

{ #category : #tests }
SWProjectSourceTest >> testCodeGenerationOfRuby [

	| tmp1 tmp3 |
	tmp3 := SWTranspilerOfRuby new.
	tmp3
		source: hello;
		transpileProgram.
	tmp1 := tmp3 contents.
	self
		assert: tmp1
		equals:
			(String crlf join:
				 { '#!/usr/bin/ruby'. 'puts("Hello, World!")'.
				 '' })
]
