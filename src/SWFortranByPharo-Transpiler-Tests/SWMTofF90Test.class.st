Class {
	#name : #SWMTofF90Test,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-Transpiler-Tests-F90'
}

{ #category : #tests }
SWMTofF90Test >> test_01_Transcript [
	|mt|
	mt := SWMTofF90 new
		payload: (SWMTofF90 methodBodyTranspilerClass new: (SWTestProgram getMy: 39) with: { SWTestProgram });
		yourself.
	mt transpile.
	mt contents inspect.
]
