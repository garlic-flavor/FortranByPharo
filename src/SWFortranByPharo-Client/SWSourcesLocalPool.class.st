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
SWSourcesLocalPool >> add: arg1 [

	self sources at: arg1 moduleName put: arg1
]

{ #category : #'as yet unclassified' }
SWSourcesLocalPool >> get: arg1 [

	^ self get: arg1 withTranspilerMethodOf: #transpile
]

{ #category : #'as yet unclassified' }
SWSourcesLocalPool >> get: arg1 withTranspilerMethodOf: arg2 [

	^ self sources at: arg1 ifAbsentPut: [ 
		  | tmp1 tmp2 tmp4 tmp6 |
		  tmp4 := SWSourceOld new.
		  tmp4
			  type: self type;
			  classes: { (Smalltalk globals at: arg1) }.
		  tmp1 := tmp4 yourself.
		  tmp6 := self transpilerClass new.
		  tmp6
			  pool: self;
			  source: tmp1;
			  perform: arg2.
		  tmp2 := tmp6 yourself.
		  tmp1
			  contents: tmp2 contents;
			  yourself ]
]

{ #category : #'as yet unclassified' }
SWSourcesLocalPool >> getAsSub: arg1 [

	^ self get: arg1 withTranspilerMethodOf: #transpileAsModule
]

{ #category : #initialization }
SWSourcesLocalPool >> reset: arg1 [

	self sources removeKey: arg1 ifAbsent: [  ]
]

{ #category : #accessing }
SWSourcesLocalPool >> sources [

	^ sources ifNil: [ sources := Dictionary new ] ifNotNil: [ sources ]
]

{ #category : #accessing }
SWSourcesLocalPool >> sources: arg1 [

	sources := arg1
]

{ #category : #accessing }
SWSourcesLocalPool >> transpilerClass [

	self type = #f90 ifTrue: [ ^ SWTranspilerOfFortran ].
	self type = #rb ifTrue: [ ^ SWTranspilerOfRuby ].
	self type = #mjs ifTrue: [ ^ SWTranspilerOfJs ].
	self error: 'NO IMPLEMENTATION!'
]

{ #category : #accessing }
SWSourcesLocalPool >> type [

	^ type
]

{ #category : #accessing }
SWSourcesLocalPool >> type: arg1 [

	type := arg1
]
