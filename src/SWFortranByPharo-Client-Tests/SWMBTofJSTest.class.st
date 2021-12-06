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

	Transcript
		show: 'Hello, world!';
		cr;
		cr
]

{ #category : #'as yet unclassified' }
SWMBTofJSTest >> program_02 [

	SWFStd print: 'Hello, World!'
]

{ #category : #'as yet unclassified' }
SWMBTofJSTest >> program_03 [

	| tmp1 tmp2 |
	tmp2 := SWVariableInfo new.
	tmp2
		type: Float;
		addProperty: #const.
	tmp1 := tmp2 yourself.
	tmp1 := 3.1415926535.
	^ tmp1 * 2.23620679
]

{ #category : #tests }
SWMBTofJSTest >> testTranspile_program_01 [

	| tmp2 |
	tmp2 := SWMBTofJS new: #program_01 types: { self class }.
	tmp2
		type: #js;
		logging: true.
	tmp2 transpile inspect
]
