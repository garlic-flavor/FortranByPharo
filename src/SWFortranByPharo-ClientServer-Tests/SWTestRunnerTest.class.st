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
	debugMode := true.
	self build inspect.
]

{ #category : #running }
SWTestRunnerTest class >> go [
	<script>
	super go
]

{ #category : #'as yet unclassified' }
SWTestRunnerTest class >> moduleTranspilerClass [
	^ SWMTofJS
]

{ #category : #tests }
SWTestRunnerTest >> test_01 [
	SWStd print: 'hello!'.
]
