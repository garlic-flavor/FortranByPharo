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
		show: 'Hello, good-bye!';
		cr;
		cr
]

{ #category : #'tests - source' }
SWMBTofJSTest >> program_02 [

	SWStd print: 'Hello, World!'
]

{ #category : #'tests - source' }
SWMBTofJSTest >> program_03 [

	| tmp1 |
	tmp1 := SWVariableInfo new
		type: Integer;
		addProperty: #const;
		yourself.
	tmp1 := 3.1415926535.

	^ tmp1 * 2.23620679
]

{ #category : #tests }
SWMBTofJSTest >> testAnalyze_program_01 [
	(SWStackAnalyzer new: #program_01 with: { self class }) ready; inspect
]

{ #category : #tests }
SWMBTofJSTest >> testSourceHash [
	self
		deny: (SWMBTofJS new: #program_01 with: {self class}) sourceHash
		equals: (SWMBTofJS new: #program_02 with: {self class}) sourceHash
]

{ #category : #tests }
SWMBTofJSTest >> testTranspile_program_01 [

	(self transpile_program: #program_01) stream contents inspect

]

{ #category : #tests }
SWMBTofJSTest >> testTranspile_program_02 [

	(self transpile_program: #program_02)
		inspect
]

{ #category : #tests }
SWMBTofJSTest >> transpile_program: selector [

	^ (SWMBTofJS new: selector with: { self class })
		logging: true;
		transpile;
		yourself.

]
