"
A SWMBTofJSTest is a test class for testing the behavior of SWMBTofJS
"
Class {
	#name : #SWMBTofJSTest,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-Client-Tests-Transpiler'
}

{ #category : #'tests - source' }
SWMBTofJSTest >> program_01 [
	Transcript show: 'Hello, world!'; cr
]

{ #category : #tests }
SWMBTofJSTest >> testTranspile_program_01 [
	((SWMBTofJS
		decode: #program_01
		types: {self class})
		type: #js;
		logging: true;
		transpile) inspect
]
