Class {
	#name : #SWTestRunnerTest,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-Transpiler-Tests'
}

{ #category : #building }
SWTestRunnerTest class >> build [
	<script>
	|mt|
	mt := SWMTofJS newFrom: self.
	mt transpile.
	mt inspect
]

{ #category : #tests }
SWTestRunnerTest >> test_01 [
	Transcript show: 'hello'; cr
]
