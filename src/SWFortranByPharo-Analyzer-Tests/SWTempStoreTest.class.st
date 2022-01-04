"
A SWTempStoreTest is a test class for testing the behavior of SWTempStore
"
Class {
	#name : #SWTempStoreTest,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-Analyzer-Tests-Slot'
}

{ #category : #tests }
SWTempStoreTest >> testNextTemporalVariableNameOf [

	| tmp1 tmp3 |
	tmp1 := Set new.
	tmp3 := nil.
	256 timesRepeat: [ 
		tmp3 := SWTempStore nextTemporalVariableNameOf: tmp3.
		self deny: (tmp1 includes: tmp3).
		tmp1 add: tmp3 ]
]
