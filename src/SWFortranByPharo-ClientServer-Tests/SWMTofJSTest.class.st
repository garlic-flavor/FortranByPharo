"
A SWMTofJSTest is a test class for testing the behavior of SWMTofJS
"
Class {
	#name : #SWMTofJSTest,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-ClientServer-Tests'
}

{ #category : #tests }
SWMTofJSTest >> test_01 [
	|mod output|
	mod := SWMTofJS newMainProgramFrom: SWTestProgram_01.
	mod stream newline: String cr.
	mod transpile.
	output := mod stream contents.
	self assert: output equals: 'console.log("Hello, good-bye!");
'.
]
