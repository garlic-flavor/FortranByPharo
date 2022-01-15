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
	project := SWMTofJS newFrom: SWTestProgram_01.
	project stream newline: String cr.
	project transpile.
	self assert: project contents equals: 'console.log("Hello, good-bye!");
'.

]

{ #category : #tests }
SWPTofJSTest >> test_program_02 [
	|module result runner|
	module := SWMTofJS newFrom: SWTestProgram_02.
	module stream newline: String cr.
	module transpile.
	result := module contents.
	runner := SWPRofJS new.
	(runner go: module) inspect


]
