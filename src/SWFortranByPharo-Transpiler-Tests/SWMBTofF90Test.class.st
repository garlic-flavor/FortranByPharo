Class {
	#name : #SWMBTofF90Test,
	#superclass : #SWTranspilerTestBaseF90,
	#category : #'SWFortranByPharo-Transpiler-Tests-F90'
}

{ #category : #tests }
SWMBTofF90Test >> test_0010_nop [
	self resultWith: {  } equals: 'program SWTestProgram_0010_nop
end program
'
]

{ #category : #tests }
SWMBTofF90Test >> test_0410_Transcript [
	|transpiler result|
	transpiler := self transpileNo: 39 with: {  }.
	result := transpiler stream contents.
	self assert: result equals: 'print *, "Hello, good-bye!";
print *, '''';
print *, '''';
'
]

{ #category : #utilities }
SWMBTofF90Test >> transpile: aMethod with: operands [
	(module pool transpilerFor: aMethod with: operands)
		transpileAsMain

]
