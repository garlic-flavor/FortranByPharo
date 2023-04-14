"
A SWServerStatusTest is a test class for testing the behavior of SWServerStatus
"
Class {
	#name : #SWServerStatusTest,
	#superclass : #SWTestRunnerJS,
	#instVars : [
		'status'
	],
	#category : #'SWFortranByPharo-ClientServer-Tests-Common'
}

{ #category : #running }
SWServerStatusTest class >> go [ 
	<script>
	super go
]

{ #category : #initialization }
SWServerStatusTest class >> setupTranspiler: mt [
	SWServerStatus setupTranspiler: mt.
	super setupTranspiler: mt
]

{ #category : #accessing }
SWServerStatusTest class >> solveDependencies: mt [
	SWServerStatus solveDependencies: mt.
	mt transpile: SWServerStatus.
	super solveDependencies: mt

]

{ #category : #building }
SWServerStatusTest class >> tryBuild [
	<script>
	self tryBuild: [
		moduleTranspiler pool haltAt: #anySatisfy:
	]
]

{ #category : #running }
SWServerStatusTest >> setUp [
	super setUp.
	status := SWServerStatus new.

]

{ #category : #tests }
SWServerStatusTest >> testStonOn [
	|status2|
	status ok;
		message: 'the requested method is not implemented.';
		toComplete: 100.
	status2 := SWServerStatus fromSton: (STON reader on: (status toString) readStream).
	self assert: [status2 isGood]
]
