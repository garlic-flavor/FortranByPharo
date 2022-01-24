Class {
	#name : #SWTestRunnerTest,
	#superclass : #SWTestRunner,
	#category : #'SWFortranByPharo-ClientServer-Tests'
}

{ #category : #building }
SWTestRunnerTest class >> build [
	^ super build
]

{ #category : #'as yet unclassified' }
SWTestRunnerTest class >> buildThenInspect [
	<script>
	self build contents inspect.
]

{ #category : #running }
SWTestRunnerTest class >> go [
	<script>
	|module result|
	module := self build.
	result := (SWPRofJS go: module).
	(STON reader
		on: result message readStream;
		next) inspect
]

{ #category : #'as yet unclassified' }
SWTestRunnerTest class >> moduleTranspilerClass [
	^ SWMTofJS
]

{ #category : #tests }
SWTestRunnerTest >> test_01 [
	SWStd print: 'hello!'.
]
