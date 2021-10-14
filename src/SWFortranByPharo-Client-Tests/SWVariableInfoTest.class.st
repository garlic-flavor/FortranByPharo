"
A SWVariableInfoTest is a test class for testing the behavior of SWVariableInfo
"
Class {
	#name : #SWVariableInfoTest,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-Client-Tests-Transpiler'
}

{ #category : #tests }
SWVariableInfoTest >> testNextTemporalVariableNameOf [
	|dict name|
	dict := Set new.
	name := nil.
	256 timesRepeat: [
		name := SWVariableInfo nextTemporalVariableNameOf: name.
		self deny: (dict includes: name).
		dict add: name
	].
]
