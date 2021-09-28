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
SWTestBase class >> mjs_requirements: transpiler [
	transpiler
		putImportNative: 'TestCase' from: 'Pharo.mjs'

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
	^ self runAsClient ifTrue: [ |res status message|
		self usingPharoServer ifTrue: [ 
			SWServer start.
		].
		res := project go.
		status := SWServerStatus fromSton: (STON reader on: res readStream; yourself).
		message := status message.
		status isOk ifFalse: [
			status inspect.
			self error: 'The execution failed.'
		].
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

{ #category : #'as yet unclassified' }
SWTestBase >> ready [
	self ready: self class name
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
