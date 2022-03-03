Class {
	#name : #SWTestRunnerJS,
	#superclass : #SWTestRunner,
	#category : #'SWFortranByPharo-ClientServer-Client'
}

{ #category : #constants }
SWTestRunnerJS class >> moduleTranspilerClass [
	^ SWMTofJS
]

{ #category : #constants }
SWTestRunnerJS class >> projectRunnerClass [
	^ SWPRofJS
]

{ #category : #private }
SWTestRunnerJS class >> solveDependencies: mt [
	super solveDependencies: mt.
	mt transpile: SWTestRunnerJS
]
