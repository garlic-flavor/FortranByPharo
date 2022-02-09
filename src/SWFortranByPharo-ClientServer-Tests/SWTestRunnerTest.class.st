Class {
	#name : #SWTestRunnerTest,
	#superclass : #SWTestRunner,
	#category : #'SWFortranByPharo-ClientServer-Tests-Client'
}

{ #category : #debug }
SWTestRunnerTest class >> buildThenInspect [
	<script>
	(self build: false) inspect.
]

{ #category : #running }
SWTestRunnerTest class >> go [
	<script>
	super go
]

{ #category : #accessing }
SWTestRunnerTest class >> moduleTranspilerClass [
	^ SWMTofJS
]

{ #category : #tests }
SWTestRunnerTest >> test_01 [
	SWStd print: 'hello!'.
]
