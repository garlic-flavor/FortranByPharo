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

	(self transpile_program: #program_01)
		stream contents inspect
]

{ #category : #tests }
SWMBTofJSTest >> testTranspile_program_02 [

	(self transpile_program: #program_02)
		inspect
]

{ #category : #tests }
SWMBTofJSTest >> transpile_program: selector [

	^ (SWMBTofJS new: selector types: { self class })
		type: #js;
		logging: true;
		transpile;
		yourself.

]
