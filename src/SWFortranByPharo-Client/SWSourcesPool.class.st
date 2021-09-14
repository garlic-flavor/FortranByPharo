"
I hold SWSources and put it to the server.
"
Class {
	#name : #SWSourcesPool,
	#superclass : #Object,
	#instVars : [
		'sources',
		'client'
	],
	#classVars : [
		'default'
	],
	#category : #'SWFortranByPharo-Client'
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

{ #category : #initialization }
SWSourcesPool >> initialize [
	super initialize
]

{ #category : #accessing }
SWSourcesPool >> sources [

	^ sources ifNil: [ sources := Dictionary new ]
]

{ #category : #accessing }
SWSourcesPool >> sources: anObject [

	sources := anObject
]
