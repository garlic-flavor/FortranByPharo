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
	self build inspect.
]

{ #category : #running }
SWTestRunnerTest class >> go [
	<script>
	|module|
	module := self build.
	(SWPRofJS go: module) inspect
]

{ #category : #'as yet unclassified' }
SWTestRunnerTest class >> moduleTranspilerClass [
	^ SWMTofJS
]

{ #category : #tests }
SWTestRunnerTest >> test_01 [
	Transcript show: 'hello'; cr
]
