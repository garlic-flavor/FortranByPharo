"
I manage SWSources.
"
Class {
	#name : #SWSourcesLocalPoolOld,
	#superclass : #Object,
	#instVars : [
		'sources',
		'type'
	],
	#classVars : [
		'localDirectory'
	],
	#category : #'SWFortranByPharo-Client-Client-Deprecated'
}

{ #category : #adding }
SWSourcesLocalPoolOld >> add: aSource [
	self sources at: aSource moduleName put: aSource
]

{ #category : #'as yet unclassified' }
SWSourcesLocalPoolOld >> get: aModuleName [
	^ self get: aModuleName withTranspilerMethodOf: #transpile.

]

{ #category : #'as yet unclassified' }
SWSourcesLocalPoolOld >> get: aModuleName withTranspilerMethodOf: aMethod [
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
SWSourcesLocalPoolOld >> getAsSub: aModuleName [
	^ self get: aModuleName withTranspilerMethodOf: #transpileAsModule
]

{ #category : #initialization }
SWSourcesLocalPoolOld >> reset: aModuleName [
	self sources removeKey: aModuleName ifAbsent: [  ]
]

{ #category : #accessing }
SWSourcesLocalPoolOld >> sources [

	^ sources ifNil: [ sources := Dictionary new ]
]

{ #category : #accessing }
SWSourcesLocalPoolOld >> sources: anObject [

	sources := anObject
]

{ #category : #accessing }
SWSourcesLocalPoolOld >> transpilerClass [ 
	self type = #f90 ifTrue: [ ^ SWTranspilerOfFortran ].
	self type = #rb ifTrue: [ ^ SWTranspilerOfRuby ].
	self type = #mjs ifTrue: [ ^ SWTranspilerOfJs ].
	self error: 'NO IMPLEMENTATION!'.
]

{ #category : #accessing }
SWSourcesLocalPoolOld >> type [
	
	^ type
]

{ #category : #accessing }
SWSourcesLocalPoolOld >> type: anObject [

	type := anObject
]
