"
I implements basic functionarity to run tests with SWServer.
"
Class {
	#name : #SWTestBase,
	#superclass : #TestCase,
	#instVars : [
		'type',
		'project',
		'runAsClient',
		'usingPharoServer'
	],
	#category : #'SWFortranByPharo-ClientServer-Tests'
}

{ #category : #'code generation' }
SWTestBase class >> mjs_requirements: transpiler [
	transpiler
		putImportNative: 'TestCase' from: 'Pharo.mjs'

]

{ #category : #running }
SWTestBase class >> program [
	|runner|
	runner := self new.
	(self methods select: [ :aMethod | aMethod protocol  beginsWith: 'test']) do: [ :each |
		each valueWithReceiver: runner arguments: #()
	]
]

{ #category : #'code generation' }
SWTestBase class >> rb_requirements [
	^ { 
		'Pharo.rb'
	}
]

{ #category : #'code generation' }
SWTestBase class >> rb_tearDownUsing: transpiler [

]

{ #category : #asserting }
SWTestBase >> assertLines: left equal: right [
	"I compare left and right ignoring line delimiter chracters."
	self assert: (left copyReplaceAll: String lf with: String cr) equals: right
]

{ #category : #'code generation - running' }
SWTestBase >> go [
	"I run tests on the server."
	(self runAsClient and: [self usingPharoServer]) ifTrue: [ 
		SWServer start.
	].
	self runAsClient ifTrue: [|status|
		status := project go.
		status socket close.
	] ifFalse: [
		project goDomestic.
	].
	SWServer isRunning ifTrue: [ SWServer stop ].

]

{ #category : #asserting }
SWTestBase >> mustFail: aBlock [
	"When aBlock ends without any Errors, I throw an Error."
	[ 
		aBlock value
	] on: Exception do: [
		^ true
	].
	self error: aBlock asString, ' must fail.'
]

{ #category : #'code generation - accessing' }
SWTestBase >> ready [
	self ready: self class name
]

{ #category : #'code generation - accessing' }
SWTestBase >> ready: aModuleName [
	project :=( SWProjectOld of: self type)
			moduleName: aModuleName;
			yourself.
	^ self

]

{ #category : #'code generation - accessing' }
SWTestBase >> runAsClient [

	^ runAsClient ifNil: [ runAsClient := false ]
]

{ #category : #'code generation - accessing' }
SWTestBase >> runAsClient: anObject [

	runAsClient := anObject
]

{ #category : #running }
SWTestBase >> setUp [
	super setUp.

]

{ #category : #running }
SWTestBase >> tearDown [
	super tearDown
]

{ #category : #asserting }
SWTestBase >> type [

	^ type
]

{ #category : #asserting }
SWTestBase >> type: anObject [

	type := anObject
]

{ #category : #'code generation - accessing' }
SWTestBase >> usingPharoServer [

	^ usingPharoServer ifNil: [ usingPharoServer := false ]
]

{ #category : #'code generation - accessing' }
SWTestBase >> usingPharoServer: anObject [

	usingPharoServer := anObject.

]
