Class {
	#name : #SWProjectTest,
	#superclass : #TestCase,
	#instVars : [
		'project',
		'client'
	],
	#category : #'SWFortranByPharo-Client-Tests-Deprecated'
}

{ #category : #running }
SWProjectTest >> setUp [

	| tmp2 |
	super setUp.
	SWServer start.
	client := SWClientView new.
	tmp2 := SWProjectOld new.
	tmp2
		programs: { SWTestHelloWorld new };
		client: client.
	project := tmp2 yourself
]

{ #category : #running }
SWProjectTest >> tearDown [

	super tearDown.
	client socket close.
	SWServer stop
]

{ #category : #test }
SWProjectTest >> testCompileAllAsFortran [

	project
		putAll;
		compileAll
]

{ #category : #test }
SWProjectTest >> testGo [

	| tmp1 |
	tmp1 := project go.
	self
		assert: (tmp1 at: #code) equals: 200;
		assert: (tmp1 at: #stdout) equals: ' Hello, World!' , String lf
]

{ #category : #test }
SWProjectTest >> testGo2 [

	| tmp1 |
	project type: #rb.
	tmp1 := project go.
	self
		assert: (tmp1 at: #code) equals: 200;
		assert: (tmp1 at: #stdout) equals: 'Hello, World!' , String lf
]

{ #category : #test }
SWProjectTest >> testGoDomestic [

	| tmp1 |
	tmp1 := project goDomestic.
	self assert: tmp1 equals: 'Hello, World!'
]

{ #category : #test }
SWProjectTest >> testLinkAllAsFortran [

	project
		putAll;
		compileAll;
		linkAll
]

{ #category : #test }
SWProjectTest >> testPutAll [

	project putAll
]

{ #category : #test }
SWProjectTest >> testRun [

	| tmp1 |
	project
		putAll;
		compileAll;
		linkAll.
	tmp1 := project run.
	self
		assert: (tmp1 at: #code) equals: 200;
		assert: (tmp1 at: #stdout) equals: ' Hello, World!' , String lf
]
