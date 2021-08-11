Class {
	#name : #SWTestBase,
	#superclass : #TestCase,
	#classVars : [
		'client',
		'project',
		'source'
	],
	#category : #'SWFortranByPharo-Base-Tests'
}

{ #category : #'code generation' }
SWTestBase class >> classes [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWTestBase class >> go [
	self setUp.
	^ [ project go ] ensure: [ self tearDown ]
]

{ #category : #'code generation' }
SWTestBase class >> setUp [
	SWServer start.
	client := SWClientView new.
	self setUpForTranspile

]

{ #category : #'code generation' }
SWTestBase class >> setUpForTranspile [
	source := SWSource new
		type: self type;
		classes: {SWStd. SWTestBase}, self classes, {self};
		yourself.
	project := SWProject new
		sources: { source };
		client: client;
		yourself.
]

{ #category : #'code generation' }
SWTestBase class >> tearDown [
	client socket close.
	SWServer stop.
		

]

{ #category : #'code generation' }
SWTestBase class >> transpile [
	self setUpForTranspile.
	^ source contents

]

{ #category : #'code generation' }
SWTestBase class >> type [
	^ self subclassResponsibility 
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
