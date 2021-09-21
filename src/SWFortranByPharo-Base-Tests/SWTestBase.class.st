Class {
	#name : #SWTestBase,
	#superclass : #TestCase,
	#instVars : [
		'type',
		'project',
		'runAsClient',
		'usingPharoServer'
	],
	#category : #'SWFortranByPharo-Base-Tests'
}

{ #category : #'code generation' }
SWTestBase class >> mjs_requirements [
	^ { 
		{'Pharo.mjs'. {'TestCase'}}
	}
]

{ #category : #'code generation' }
SWTestBase class >> mjs_setUpUsing: transpiler [
]

{ #category : #'code generation' }
SWTestBase class >> mjs_tearDownUsing: transpiler [

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
	self assert: (left copyReplaceAll: String lf with: String cr) equals: right
]

{ #category : #'code generation - running' }
SWTestBase >> go [
	^ self runAsClient ifTrue: [ |res status|
		self usingPharoServer ifTrue: [ 
			SWServer start.
		].
		res := project go.
		status := SWServerStatus fromSton: (STON reader on: res readStream; yourself).
		status isOk ifFalse: [|message|
			message := status message.
		].
		status inspect.
	] ifFalse: [
		project goDomestic.
	]

]

{ #category : #asserting }
SWTestBase >> mustFail: aBlock [
	[ 
		aBlock value
	] on: Exception do: [
		^ true
	].
	self error: aBlock asString, ' must fail.'
]

{ #category : #'code generation - accessing' }
SWTestBase >> ready: aModuleName [
	self type = #mjs ifTrue: [ 
		project := SWProjectOfJs new
			moduleName: aModuleName;
			yourself.
		^ self
	].
	self halt.
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
	project ifNotNil: [ project close ].
	SWServer isRunning ifTrue: [ SWServer stop ].
	super tearDown
]

{ #category : #'code generation - accessing' }
SWTestBase >> type [

	^ type
]

{ #category : #'code generation - accessing' }
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
