"
A SWServerStatusTest is a test class for testing the behavior of SWServerStatus
"
Class {
	#name : #SWServerStatusTest,
	#superclass : #SWTestRunner,
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

{ #category : #accessing }
SWServerStatusTest class >> moduleTranspilerClass [
	^ SWMTofJS
]

{ #category : #accessing }
SWServerStatusTest class >> solveDependenciesUsing: transpiler [
	super solveDependenciesUsing: transpiler.
	transpiler
		transpile: SWServerStatus
]

{ #category : #building }
SWServerStatusTest class >> tryBuild [
	<script>
	|mt|
	mt := self newModuleTranspiler.
	mt payload haltAt: #toString.
	mt transpile inspect.
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
