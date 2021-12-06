"
I manage SWSources.
"
Class {
	#name : #SWSourcesLocalPool,
	#superclass : #Object,
	#instVars : [
		'sources',
		'type'
	],
	#classVars : [
		'localDirectory'
	],
	#category : #'SWFortranByPharo-Client-Client'
}

{ #category : #adding }
SWSourcesLocalPool >> add: aSource [
	self sources at: aSource moduleName put: aSource
]

{ #category : #'as yet unclassified' }
SWSourcesLocalPool >> get: aModuleName [
	^ self get: aModuleName withTranspilerMethodOf: #transpile.

]

{ #category : #'as yet unclassified' }
SWSourcesLocalPool >> get: aModuleName withTranspilerMethodOf: aMethod [
	^ self sources at: aModuleName ifAbsentPut: [|source transpiler|
			source := SWSourceOld new
				type: self type;
				classes: { Smalltalk globals at: aModuleName };
				yourself.
			transpiler := self transpilerClass new
				pool: self;
				source: source;
				perform: aMethod;
				yourself.
			source
				contents: transpiler contents;
				yourself.
	]
]

{ #category : #'as yet unclassified' }
SWSourcesLocalPool >> getAsSub: aModuleName [
	^ self get: aModuleName withTranspilerMethodOf: #transpileAsModule
]

{ #category : #initialization }
SWSourcesLocalPool >> reset: aModuleName [
	self sources removeKey: aModuleName ifAbsent: [  ]
]

{ #category : #accessing }
SWSourcesLocalPool >> sources [

	^ sources ifNil: [ sources := Dictionary new ]
]

{ #category : #accessing }
SWSourcesLocalPool >> sources: anObject [

	sources := anObject
]

{ #category : #accessing }
SWSourcesLocalPool >> transpilerClass [ 
	self type = #f90 ifTrue: [ ^ SWTranspilerOfFortran ].
	self type = #rb ifTrue: [ ^ SWTranspilerOfRuby ].
	self type = #mjs ifTrue: [ ^ SWTranspilerOfJs ].
	self error: 'NO IMPLEMENTATION!'.
]

{ #category : #accessing }
SWSourcesLocalPool >> type [
	
	^ type
]

{ #category : #accessing }
SWSourcesLocalPool >> type: anObject [

	type := anObject
]
