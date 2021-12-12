"
A SWPTofJSTest is a test class for testing the behavior of SWPTofJS
"
Class {
	#name : #SWPTofJSTest,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-Client-Tests-Transpiler'
}

{ #category : #tests }
SWPTofJSTest >> test_program_01 [
	|project|
	project := SWPTofJS newFrom: SWTestProgram_01.
	project inspect.
"
	project transpile.
	project main contents inspect.
"
]
