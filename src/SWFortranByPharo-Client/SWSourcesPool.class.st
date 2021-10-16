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

{ #category : #accessing }
SWSourcesPool >> get: aModuleName withTranspilerMethodOf: aMethod [
	^ self sources at: aModuleName ifAbsent: [
		(super get: aModuleName withTranspilerMethodOf: aMethod)
			putOn: self client;
			yourself
	]
]
