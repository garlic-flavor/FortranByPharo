"
I hold SWSources and put it to the server.
"
Class {
	#name : #SWSourcesPool,
	#superclass : #Object,
	#instVars : [
		'sources',
		'client',
		'type'
	],
	#classVars : [
		'default'
	],
	#category : #'SWFortranByPharo-Client-Client'
}

{ #category : #accessing }
SWSourcesPool class >> default [
	^ default ifNil: [ default := self new ]
]

{ #category : #initialization }
SWSourcesPool class >> reset [
	<script>
	default := nil
]

{ #category : #adding }
SWSourcesPool >> add: aSource [
	self sources at: aSource moduleName put: aSource
]

{ #category : #accessing }
SWSourcesPool >> client [

	^ client ifNil: [ client := SWClient new ]
]

{ #category : #accessing }
SWSourcesPool >> client: anObject [

	client := anObject
]

{ #category : #'as yet unclassified' }
SWSourcesPool >> get: aModuleName [
	^ self sources at: aModuleName ifAbsentPut: [|source transpiler|
			source := SWSource new
				type: self type;
				classes: { Smalltalk globals at: aModuleName };
				yourself.
			transpiler := self transpilerClass new
				pool: self;
				source: source;
				yourself.
			source contents: transpiler transpile contents.
			(self client head: source filename) ifNil: [
				self client put: source filename contents: source contents
			].
			source
	]
]

{ #category : #initialization }
SWSourcesPool >> initialize [
	super initialize
]

{ #category : #'instance creation' }
SWSourcesPool >> newTranspiler [
	^ (self transpilerClass) new
]

{ #category : #accessing }
SWSourcesPool >> sources [

	^ sources ifNil: [ sources := Dictionary new ]
]

{ #category : #accessing }
SWSourcesPool >> sources: anObject [

	sources := anObject
]

{ #category : #accessing }
SWSourcesPool >> transpilerClass [ 
	self type = #f90 ifTrue: [ ^ SWTranspilerOfFortran ].
	self type = #rb ifTrue: [ ^ SWTranspilerOfRuby ].
	self type = #mjs ifTrue: [ ^ SWTranspilerOfJs ].
	self error: 'NO IMPLEMENTATION!'.
]

{ #category : #accessing }
SWSourcesPool >> type [
	
	^ type ifNil: [ self error: 'I need to be set a type of me.' ]
]

{ #category : #accessing }
SWSourcesPool >> type: anObject [

	type := anObject
]
