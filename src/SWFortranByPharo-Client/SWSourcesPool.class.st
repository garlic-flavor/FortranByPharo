"
I hold SWSources and put it to the server.
"
Class {
	#name : #SWSourcesPool,
	#superclass : #SWSourcesLocalPool,
	#instVars : [
		'client'
	],
	#classVars : [
		'localScriptDirectory'
	],
	#category : #'SWFortranByPharo-Client-Client'
}

{ #category : #'as yet unclassified' }
SWSourcesPool class >> localScriptDirectory [
	^ localScriptDirectory ifNil: [
		localScriptDirectory := ((IceRepository repositories select: [ :each |
			each name = #FortranByPharo
		]) first location / 'script') relativeTo: FileLocator imageDirectory
	]
]

{ #category : #initialization }
SWSourcesPool class >> reset [
	<script>
	localScriptDirectory := nil
]

{ #category : #accessing }
SWSourcesPool >> client [

	^ client ifNil: [ client := SWClient new ]
]

{ #category : #accessing }
SWSourcesPool >> client: anObject [

	client := anObject
]

{ #category : #'initialize-release' }
SWSourcesPool >> close [
	client ifNotNil: [ client close. ]
]

{ #category : #'as yet unclassified' }
SWSourcesPool >> get: aModuleName [
	^ self sources at: aModuleName ifAbsent: [|source|
			source := super get: aModuleName.
			(self client head: source filename) ifNil: [
				self client put: source filename contents: source contents
			].
			source
	]
]
