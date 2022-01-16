Class {
	#name : #SWTestRunnerTest,
	#superclass : #SWTestRunner,
	#category : #'SWFortranByPharo-ClientServer-Tests'
}

{ #category : #building }
SWTestRunnerTest class >> build [
	<script>
	super build
]

{ #category : #'as yet unclassified' }
SWTestRunnerTest class >> moduleTranspilerClass [
	^ SWMTofJS
]

{ #category : #tests }
SWTestRunnerTest >> test_01 [
	Transcript show: 'hello'; cr
]
