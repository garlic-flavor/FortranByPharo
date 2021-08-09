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

{ #category : #accessing }
SWTestBase class >> classMethodDeclarationFilter: aSymbol [
	^ false
]

{ #category : #accessing }
SWTestBase class >> classes [
	^ self subclassResponsibility 
]

{ #category : #navigating }
SWTestBase class >> go [
	self setUp.
	^ [ project go ] ensure: [ self tearDown ]
]

{ #category : #accessing }
SWTestBase class >> instanceVariableDeclarationFilter: aSymbol [
	^ true
]

{ #category : #accessing }
SWTestBase class >> methodDeclarationFilter: aSymbol [
	^ true
]

{ #category : #initialization }
SWTestBase class >> setUp [
	SWServer start.
	client := SWClientView new.
	source := SWSource new
		type: self type;
		classes: {SWStd. SWTestBase}, self classes;
		yourself.
	project := SWProject new
		sources: { source };
		client: client;
		yourself.
]

{ #category : #running }
SWTestBase class >> tearDown [
	client socket close.
	SWServer stop.
		

]

{ #category : #tests }
SWTestBase class >> transpile [
	self setUp.
	^ [ source contents ] ensure: [ self tearDown ]

]

{ #category : #accessing }
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
