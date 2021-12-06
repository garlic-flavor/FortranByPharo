Class {
	#name : #SWVariableInfoTest,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-Client-Tests-Transpiler'
}

{ #category : #tests }
SWVariableInfoTest >> testNextTemporalVariableNameOf [

	| tmp1 tmp3 |
	tmp1 := Set new.
	tmp3 := nil.
	256 timesRepeat: [ 
		tmp3 := SWVariableInfo nextTemporalVariableNameOf: tmp3.
		self deny: (tmp1 includes: tmp3).
		tmp1 add: tmp3 ]
]
