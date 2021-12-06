Class {
	#name : #SWNag3Line,
	#superclass : #SWType,
	#instVars : [
		'p1',
		'p2'
	],
	#category : #'SWFortranByPharo-Client-Tests'
}

{ #category : #initialization }
SWNag3Line >> initialize [

	super initialize.
	p1 := SWVariableInfo new type: SWNag3Point.
	p2 := SWVariableInfo new type: SWNag3Point
]
