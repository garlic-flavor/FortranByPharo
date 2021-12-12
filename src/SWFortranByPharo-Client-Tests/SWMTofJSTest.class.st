"
A SWMTofJSTest is a test class for testing the behavior of SWMTofJS
"
Class {
	#name : #SWMTofJSTest,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-Client-Tests-Transpiler'
}

{ #category : #tests }
SWMTofJSTest >> test_program_01 [
	|mod|
	mod := SWMTofJS newMainProgramFrom: SWTestProgram_01.
	mod inspect
]
