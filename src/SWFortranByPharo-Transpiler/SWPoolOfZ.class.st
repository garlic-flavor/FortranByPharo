Class {
	#name : #SWPoolOfZ,
	#superclass : #SWTranspilerPool,
	#category : #'SWFortranByPharo-Transpiler'
}

{ #category : #constants }
SWPoolOfZ class >> classInfoClass [
	^ SWCDTofZ
]

{ #category : #constants }
SWPoolOfZ class >> methodBodyTranspilerClass [
	^ SWMBTofZ
]
