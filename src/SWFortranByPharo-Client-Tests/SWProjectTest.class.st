"
A SWProjectTest is a test class for testing the behavior of SWProject
"
Class {
	#name : #SWProjectTest,
	#superclass : #TestCase,
	#instVars : [
		'project',
		'client'
	],
	#category : #'SWFortranByPharo-Client-Tests-Client'
}

{ #category : #running }
SWProjectTest >> setUp [
	super setUp.
	SWServer start.
	client := SWClientView new.
	project := SWProjectOld new
		programs: { SWTestHelloWorld new  };
		client: client;
		yourself.
	"Put here a common initialization logic for tests"
]

{ #category : #running }
SWProjectTest >> tearDown [
	super tearDown.
	client socket close.
	SWServer stop.
]

{ #category : #test }
SWProjectTest >> testCompileAllAsFortran [
	project
		putAll;
		compileAll.

]

{ #category : #test }
SWProjectTest >> testGo [
	|res|
	res := project go.
	self assert: (res at: #code) equals: 200.
	self assert: (res at: #stdout) equals: ' Hello, World!', String lf.
]

{ #category : #test }
SWProjectTest >> testGo2 [
	|res|
	project type: #rb.
	res := project go.
	self assert: (res at: #code) equals: 200.
	self assert: (res at: #stdout) equals: 'Hello, World!', String lf.
]

{ #category : #test }
SWProjectTest >> testGoDomestic [
	|res|
	res := project goDomestic.
	self assert: res equals: 'Hello, World!'.
]

{ #category : #test }
SWProjectTest >> testLinkAllAsFortran [
	project
		putAll;
		compileAll;
		linkAll.

]

{ #category : #test }
SWProjectTest >> testPutAll [
	project putAll.

]

{ #category : #test }
SWProjectTest >> testRun [
	|res|
	res := project
		putAll;
		compileAll;
		linkAll;
		run.
	self assert: (res at: #code) equals: 200.
	self assert: (res at: #stdout) equals: ' Hello, World!', String lf.
]
