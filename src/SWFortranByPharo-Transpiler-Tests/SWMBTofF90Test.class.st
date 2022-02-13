Class {
	#name : #SWMBTofF90Test,
	#superclass : #SWMBTofJSTest,
	#category : #'SWFortranByPharo-Transpiler-Tests-F90'
}

{ #category : #tests }
SWMBTofF90Test >> test_01 [
	|transpiler result|
	transpiler := (self transpile_program: #_01_call_Transcript).
	result := transpiler stream contents.
	self assert: result equals: 'print *, "Hello, good-bye!";
print *, '''';
print *, '''';
'
]

{ #category : #utilities }
SWMBTofF90Test >> transpile_program: selector [
	|transpiler|
	transpiler := SWMBTofF90 new: self class superclass>>selector with: { self class }.
	transpiler logger enabled: true.
	transpiler stream newline: String cr.
	transpiler decode; transpile.
	^ transpiler

]
