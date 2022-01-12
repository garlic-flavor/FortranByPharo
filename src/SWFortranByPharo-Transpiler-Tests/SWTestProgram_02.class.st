Class {
	#name : #'SWTestProgram_02',
	#superclass : #Object,
	#category : #'SWFortranByPharo-Transpiler-Tests'
}

{ #category : #accessing }
SWTestProgram_02 class >> main [
	SWStd print: self util1
]

{ #category : #tests }
SWTestProgram_02 class >> test2_cascading [
	^ (SWServerStatus new
		failed;
		message: 'hogehoge';
		uri: 'testuri';
		yourself) toString

]

{ #category : #'as yet unclassified' }
SWTestProgram_02 class >> util1 [
	^ 'Hello, world!'
]
