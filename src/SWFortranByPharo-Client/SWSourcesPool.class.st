"
I hold SWSources and put it to the server.
"
Class {
	#name : #SWSourcesPool,
	#superclass : #SWSourcesLocalPool,
	#instVars : [
		'client'
	],
	#category : #'SWFortranByPharo-Client-Client'
}

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
	^ self sources at: aModuleName ifAbsent: [
		(super get: aModuleName)
			putOn: self client;
			yourself
	]
]
