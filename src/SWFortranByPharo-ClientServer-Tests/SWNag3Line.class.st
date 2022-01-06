Class {
	#name : #SWNag3Line,
	#superclass : #SWTypeOld,
	#instVars : [
		'p1',
		'p2'
	],
	#category : #'SWFortranByPharo-ClientServer-Tests'
}

{ #category : #initialization }
SWNag3Line >> initialize [

	super initialize.
	p1 := SWVariableTypeInfo new type: SWNag3Point.
	p2 := SWVariableTypeInfo new type: SWNag3Point
]
