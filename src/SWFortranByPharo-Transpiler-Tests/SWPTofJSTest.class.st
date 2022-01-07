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
