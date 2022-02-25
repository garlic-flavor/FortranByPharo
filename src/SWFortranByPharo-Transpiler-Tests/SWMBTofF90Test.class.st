Class {
	#name : #SWMBTofF90Test,
	#superclass : #SWTranspilerTestBase,
	#category : #'SWFortranByPharo-Transpiler-Tests-F90'
}

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

{ #category : #accessing }
SWMBTofF90Test >> transpilerClass [
	^ SWMBTofF90
]
