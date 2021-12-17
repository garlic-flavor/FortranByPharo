Class {
	#name : #'SWTestProgram_01',
	#superclass : #Object,
	#category : #'SWFortranByPharo-Client-Tests-Transpiler'
}

{ #category : #accessing }
SWTestProgram_01 class >> main [
	SWStd print: 'Hello, good-bye!'
]

{ #category : #'as yet unclassified' }
SWTestProgram_01 >> hoge [
	|dict|
	dict := Dictionary new.
	^ dict at: #hoge ifAbsentPut: [ 123 ]
]

{ #category : #'as yet unclassified' }
SWTestProgram_01 >> hoge2 [
	|arg1 arg2 arg3 arg4|
	arg1 := 'hello'.
	arg2 := 'world'.
	arg3 := 'goodbye'.
	arg4 := Dictionary new.
	arg4 at: 3 ifAbsentPut: [ self hoge. arg3, arg2, arg1 ].
]
