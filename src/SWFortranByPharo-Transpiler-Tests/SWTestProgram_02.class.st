Class {
	#name : #'SWTestProgram_02',
	#superclass : #Object,
	#category : #'SWFortranByPharo-Transpiler-Tests'
}

{ #category : #accessing }
SWTestProgram_02 class >> main [
	SWStd print: self util1
]

{ #category : #'as yet unclassified' }
SWTestProgram_02 class >> toTranspile [
	^ true
]

{ #category : #'as yet unclassified' }
SWTestProgram_02 class >> util1 [
	^ 'Hello, world!'
]
