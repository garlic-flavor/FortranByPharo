Class {
	#name : #SWTestBase,
	#superclass : #TestCase,
	#classVars : [
		'client',
		'source',
		'usingPharoServer'
	],
	#category : #'SWFortranByPharo-Base-Tests'
}

{ #category : #'code generation' }
SWTestBase class >> go [
	self setUp.
 	^ [
		SWProject new
			sources: { source };
			client: client;
			run
	] ensure: [ self tearDown ]

]

{ #category : #'code generation' }
SWTestBase class >> rb_requirements [
	^ { 
		'Pharo.rb'
	}
]

{ #category : #'code generation' }
SWTestBase class >> setUp [
	self usingPharoServer ifTrue: [
		SWServer start.
	].
	client := SWClient new.
	source := SWSource new
		classes: { self };
		type: self type;
		putTo: client;
		yourself.

]

{ #category : #'code generation' }
SWTestBase class >> tearDown [
	client close.
	SWServer isRunning ifTrue: [
		SWServer stop.
	]

]

{ #category : #'code generation' }
SWTestBase class >> transpile [
	self setUp.
	^ [ source contents ] ensure: [ self tearDown ]

]

{ #category : #'code generation' }
SWTestBase class >> type [
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SWTestBase class >> useNativeServer [
	usingPharoServer = false
]

{ #category : #'as yet unclassified' }
SWTestBase class >> usePharoServer [
	usingPharoServer := true
]

{ #category : #'as yet unclassified' }
SWTestBase class >> usingPharoServer [
	^ usingPharoServer ifNil: [ usingPharoServer = false ]
]

{ #category : #asserting }
SWTestBase >> assertLines: left equal: right [
	self assert: (left copyReplaceAll: String lf with: String cr) equals: right
]

{ #category : #'as yet unclassified' }
SWTestBase >> mustFail: aBlock [
	[ 
		aBlock value
	] on: Exception do: [
		^ true
	].
	self error: aBlock asString, ' must fail.'
]

{ #category : #running }
SWTestBase >> setUp [
	super setUp.

]
