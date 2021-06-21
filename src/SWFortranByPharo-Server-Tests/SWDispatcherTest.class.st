Class {
	#name : #SWDispatcherTest,
	#superclass : #TestCase,
	#instVars : [
		'disp'
	],
	#category : #'SWFortranByPharo-Server-Tests-Shell'
}

{ #category : #running }
SWDispatcherTest >> setUp [
	super setUp.
	disp := SWDispatcher new.
	"Put here a common initialization logic for tests"
]

{ #category : #tests }
SWDispatcherTest >> testBasicFunctionality [
	disp if: [ :obj | obj < 10 ] then: [:obj | (obj asString, ' is less than 10.') ].
	disp if: [ :obj | obj < 20 ] then: [ :obj | (obj asString, ' is less than 20.' )].

	self assert: (disp detect: 5) equals: '5 is less than 10.'. 
]
