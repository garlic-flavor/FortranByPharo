"
A SWPTofJSTest is a test class for testing the behavior of SWPTofJS
"
Class {
	#name : #SWPTofJSTest,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-Transpiler-Tests'
}

{ #category : #tests }
SWPTofJSTest >> test_program_01 [
	|project|
	project := SWPTofJS newFrom: SWTestProgram_01.
	project newline: String cr.
	project transpile.
	self assert: project main contents equals: 'console.log("Hello, good-bye!");
'.

]

{ #category : #tests }
SWPTofJSTest >> test_program_02 [
	|project result|
	project := SWPTofJS newFrom: SWTestProgram_02.
	project newline: String cr.
	project transpile.
	result := project main contents.
	self halt.

]
