"
A SWMBTofJSTest is a test class for testing the behavior of SWMBTofJS
"
Class {
	#name : #SWMBTofJSTest,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-Client-Tests-Transpiler'
}

{ #category : #'as yet unclassified' }
SWMBTofJSTest class >> toTranspile [
	^ #program
]

{ #category : #'tests - source' }
SWMBTofJSTest >> program_01 [
	Transcript show: 'Hello, world!'; cr; cr
]

{ #category : #'as yet unclassified' }
SWMBTofJSTest >> program_02 [
	SWFStd print: 'Hello, World!'
]

{ #category : #'as yet unclassified' }
SWMBTofJSTest >> program_03 [
	|pi|
	pi := SWVariableInfo new
		type: Float;
		addProperty: #const;
		yourself.
	pi := 3.1415926535.
	^ pi * 2.23620679
]

{ #category : #tests }
SWMBTofJSTest >> testTranspile_program_01 [
	((SWMBTofJS
		new: #program_01
		types: {self class})
		type: #js;
		logging: true;
		transpile) inspect
]
