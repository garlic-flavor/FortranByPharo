Class {
	#name : #SWTestBase,
	#superclass : #TestCase,
	#instVars : [
		'source',
		'client',
		'type',
		'runAsClient',
		'usingPharoServer'
	],
	#category : #'SWFortranByPharo-Base-Tests'
}

{ #category : #'code generation' }
SWTestBase class >> rb_requirements [
	^ { 
		'Pharo.rb'
	}
]

{ #category : #'as yet unclassified' }
SWTestBase class >> rb_tearDownUsing: transpiler [

]

{ #category : #asserting }
SWTestBase >> assertLines: left equal: right [
	self assert: (left copyReplaceAll: String lf with: String cr) equals: right
]

{ #category : #'code generation - accessing' }
SWTestBase >> client [

	^ client ifNil: [
		self runAsClient ifTrue: [
			self usingPharoServer ifTrue: [
				SWServer isRunning ifFalse: [ SWServer start ]
			].
			client := SWClient new
		] ifFalse: [
			nil
		]
	]
]

{ #category : #'code generation - accessing' }
SWTestBase >> client: anObject [

	client := anObject
]

{ #category : #'code generation - running' }
SWTestBase >> go [
	self runAsClient: true.
	self usingPharoServer: true.
	^ SWProject new
		sources: { self source };
		client: self client;
		run
]

{ #category : #'code generation - running' }
SWTestBase >> goOnExternalServer [
	self runAsClient: true.
	self usingPharoServer: false.
	^ SWProject new
		sources: { self source };
		client: self client;
		run
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

{ #category : #'code generation - accessing' }
SWTestBase >> source [

	^ source ifNil: [
		self runAsClient ifTrue: [
			source := SWSource new
				classes: { self class };
				type: self type;
				putTo: self client;
				yourself
		] ifFalse: [
			nil
		]
	]
]

{ #category : #'code generation - accessing' }
SWTestBase >> source: anObject [

	source := anObject
]

{ #category : #running }
SWTestBase >> tearDown [
	self client ifNotNil: [
		self client close
	].
	SWServer isRunning ifTrue: [ SWServer stop ].
	super tearDown
]

{ #category : #'code generation - accessing' }
SWTestBase >> type [
	self assert: type isNotNil.
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
